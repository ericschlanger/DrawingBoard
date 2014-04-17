
#import "CanvasViewController.h"


@interface CanvasViewController ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic) CGFloat currentLineWidth;
@property (nonatomic) CGFloat currentOpacity;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) FancyPoint *lastPointReceived;

@property (nonatomic) BOOL swipe;

@property (nonatomic, strong) MPCHandler *mpcHandler;

@property (nonatomic, strong) NSMutableArray *undoArray;

@property (nonatomic) short currentStrokeID;
@property (nonatomic) short lastStrokeID;

@property (nonatomic, strong) WYPopoverController *colorPopover;
@property (nonatomic, strong) WYPopoverController *optionsPopver;

@end

@implementation CanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Default Settings
    self.currentColor = [UIColor blackColor];
    self.currentLineWidth = 10.0f;
    self.currentOpacity = 1.0;
    self.lastPoint = CGPointMake(0, 0);
    
    // Pan ScrollView setup
    // Ensure that scrollview only allows two-finger scrolling
    for (UIGestureRecognizer *gesture in self.panScrollView.gestureRecognizers)
    {
        if([gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *panRec = (UIPanGestureRecognizer *)gesture;
            panRec.minimumNumberOfTouches = 2;
        }
    }
    self.panScrollView.delegate = self;

    
    // Initialize MCPHandler
    self.mpcHandler = [[MPCHandler alloc]init];
    [self.mpcHandler setupPeerWithDisplayName:[[UIDevice currentDevice]name]];
    [self.mpcHandler setupSession];
    [self.mpcHandler advertiseSelf:true];
    
    // Motion ColorPicker Setup
    PRYColorPicker *colorPicker = [[PRYColorPicker alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height-125, 50, 50)];
    [self.view addSubview:colorPicker];
    colorPicker.delegate = self;
    
    // Traditional ColorPicker Setup
    NKOColorPickerDidChangeColorBlock block = ^(UIColor *color)
    {
        self.currentColor = color;
    };
    NKOColorPickerView *normColorPicker = [[NKOColorPickerView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) color:self.currentColor andDidChangeColorBlock:block];
    UIViewController *colorVC = [[UIViewController alloc]init];
    [colorVC.view addSubview:normColorPicker];
    colorVC.preferredContentSize = normColorPicker.frame.size;
    self.colorPopover = [[WYPopoverController alloc]initWithContentViewController:colorVC];
    self.colorPopover.delegate = self;
    
    // Options Popover Setup
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    OptionViewController *optVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"optionsScene"];
    optVC.preferredContentSize = CGSizeMake(300, 400);
    optVC.delegate = self;
    self.optionsPopver = [[WYPopoverController alloc]initWithContentViewController:optVC];


    
    // Handle Notifcations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveData:)
                                                 name:@"DrawingBoard_ReceivedData"
                                               object:nil];
    
    // Initialize Undo Array
    self.undoArray = [[NSMutableArray alloc]init];
    
    // Set lastPointReceived as empty
    self.lastPointReceived = NULL;
}

- (void)viewDidLayoutSubviews
{
    // Set canvas size
    [self.mainImageView setFrame:CGRectMake(0, 0, 768, 1024)];
    [self.currentStrokeView setFrame:CGRectMake(0, 0, 768, 1024)];
    [self.panScrollView setContentSize:CGSizeMake(768, 1024)];
    
    // Disable scrolling if ipad
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.panScrollView.scrollEnabled = NO;
    }
}

#pragma mark - Multipeer Connectivity
- (IBAction)connect:(id)sender
{
    [self.mpcHandler setupBrowser];
    [self.mpcHandler.browser setDelegate:self];
    [self presentViewController:self.mpcHandler.browser
                       animated:YES
                     completion:nil];
}


- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Send/Receive FancyPoints

- (void)sendString:(NSString *)string
{
    NSData *cData = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    
    [self.mpcHandler.session sendData:cData toPeers:self.mpcHandler.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    if(error != NULL)
    {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (void)sendImage:(UIImage *)image
{
    NSData *cData = UIImagePNGRepresentation(self.mainImageView.image);
    NSError *error = nil;

    [self.mpcHandler.session sendData:cData toPeers:self.mpcHandler.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
    if(error != NULL)
    {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (void)didReceiveData:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSData *unCData = userInfo[@"data"];
    if([[self contentTypeForImageData:unCData] isEqual: @"image/png"])
    {
        self.mainImageView.image = [UIImage imageWithData:unCData];
    }
    else
    {
        NSString *dataString = [NSString stringWithUTF8String:[unCData bytes]];
        if(dataString != NULL)
        {
            if([dataString isEqualToString:@"ClearRequest"])
            {
                RIButtonItem *yesButton = [RIButtonItem itemWithLabel:@"Yes" action:^{
                    self.mainImageView.image = NULL;
                    self.currentStrokeView.image = NULL;
                    [self sendString:@"ClearRequestAccepted"];
                }];
                RIButtonItem *noButton = [RIButtonItem itemWithLabel:@"No"];
                
                UIAlertView *clearRequest = [[UIAlertView alloc]initWithTitle:@"Clear Request" message:@"Do you wish to clear the canvas?" cancelButtonItem:noButton otherButtonItems:yesButton, nil];
                [clearRequest show];
            }
            else if([dataString isEqualToString:@"ClearRequestAccepted"])
            {
                self.mainImageView.image = NULL;
                self.currentStrokeView.image = NULL;
            }
            else
            {
                FancyPoint *point = [[FancyPoint alloc]initFromString:dataString];
                
                // Different stroke IDs, merge images (end line)
                if(point.strokeID != self.lastStrokeID)
                {
                    
                    [self mergeStrokesToMainImageWithOpacity:[self.lastPointReceived fetchOpacity]];
                    self.lastPointReceived = NULL;
                }
                
                if(self.lastPointReceived == NULL)
                {
                    [self drawLineFromPoint:CGPointMake(point.x, point.y) toPoint:CGPointMake(point.x, point.y) withColor:[point fetchColor] andWidth:point.lineWidth andOpacity:[point fetchOpacity]];
                }
                else
                {
                    [self drawLineFromPoint:CGPointMake(self.lastPointReceived.x,self.lastPointReceived.y) toPoint:CGPointMake(point.x, point.y) withColor:[point fetchColor] andWidth:point.lineWidth andOpacity:[self.lastPointReceived fetchOpacity]];
                }
                
                self.lastPointReceived = point;
                self.lastStrokeID = point.strokeID;
            }
        }
    }
}

#pragma mark - Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Assume no stroke movement
    self.swipe = NO;
    
    // Get touch position
    UITouch *lastTouch = [touches anyObject];
    self.lastPoint = [lastTouch locationInView:self.currentStrokeView];
    
    // Set new stroke ID
    self.currentStrokeID = arc4random();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Set to true for movement
    self.swipe = YES;
    
    // Get current touch position
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self.currentStrokeView];
    
    // Only sends point if connected peers exist
    if([self.mpcHandler.session.connectedPeers count] > 0)
    {
        // Creates fancypoint from currentPoint
        FancyPoint *fancyPoint = [[FancyPoint alloc]initWithPoint:self.lastPoint andColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity andID:self.currentStrokeID];
        [self sendString:[fancyPoint toString]];
    }
    
    [self drawLineFromPoint:self.lastPoint toPoint:currentPoint withColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity];
    
    // Store last point
    self.lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Case for single dot
    if(!self.swipe)
    {
        self.lastPointReceived = NULL;
        // Draw single dot
        [self drawLineFromPoint:self.lastPoint toPoint:self.lastPoint withColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity];
        
        // Only send single dot if connected peers exist
        if([self peersConnected])
        {
            // Create fancypoint object with lastPoint
            FancyPoint *fancyPoint = [[FancyPoint alloc]initWithPoint:self.lastPoint andColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity andID:self.currentStrokeID];
            
            // Send fancyPoint
            [self sendString:[fancyPoint toString]];
        }
    }

    [self mergeStrokesToMainImageWithOpacity:self.currentOpacity];
}

#pragma mark - Drawing
- (void)drawLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 withColor:(UIColor *)color andWidth:(int)width andOpacity:(CGFloat)opacity
{
    // Start graphics context with size of frame
    UIGraphicsBeginImageContext(self.currentStrokeView.frame.size);
    
    // Draw from and to points
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.currentStrokeView.frame.size.width,self.currentStrokeView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point1.x, point1.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point2.x, point2.y);
    
    // Set line parameters
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    
    // Get & set color components from UIColor
    CGFloat red = 0, green = 0, blue = 0;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    // Draw image to stroke view
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    [self.currentStrokeView setImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    [self.currentStrokeView setAlpha:opacity];
    
    // End graphics context
    UIGraphicsEndImageContext();
}

- (void)mergeStrokesToMainImageWithOpacity:(CGFloat)opacity
{
    // Merge stroke view with main image view
    UIGraphicsBeginImageContext(self.mainImageView.frame.size);
    [self.mainImageView.image drawInRect:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    
    // Set image from context
    [self.mainImageView setImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    // Clear currentStrokeView
    self.currentStrokeView.image = nil;
    
    // End context
    UIGraphicsEndImageContext();
    
    // Remove object if undoArray count is greater/equal to 10
    if(self.undoArray.count >= 10)
    {
        [self.undoArray removeObjectAtIndex:0];
    }
    // Save old image state to undoArray
    [self.undoArray addObject:self.mainImageView.image];
}

- (void)colorChangedToColor:(UIColor *)color
{
    self.currentColor = color;
}

- (IBAction)pickColor:(id)sender
{
    UIBarButtonItem *barButton = (UIBarButtonItem*)sender;
    
    [self.colorPopover presentPopoverFromBarButtonItem:barButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (IBAction)clearCanvas:(id)sender
{
    RIButtonItem *noButton = [RIButtonItem itemWithLabel:@"No"];
    RIButtonItem *yesButton = [RIButtonItem itemWithLabel:@"Yes" action:^{
    
            if([self peersConnected])
            {
                [self sendString:@"ClearRequest"];
            }
            else
            {
                self.mainImageView.image = NULL;
                self.currentStrokeView.image = NULL;
            }
    }];
    
    UIAlertView *clearConfirm = [[UIAlertView alloc]initWithTitle:@"Clear Canvas" message:@"Are you sure?" cancelButtonItem:noButton otherButtonItems:yesButton, nil];
    [clearConfirm show];
}

- (IBAction)saveImage:(id)sender
{
    RIButtonItem *yesButton = [RIButtonItem itemWithLabel:@"Yes" action:^{
        UIImageWriteToSavedPhotosAlbum(self.mainImageView.image, nil, nil, nil);
    }];
    RIButtonItem *noButton = [RIButtonItem itemWithLabel:@"No"];
    UIAlertView *saveAlert = [[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Save to camera roll?" cancelButtonItem:noButton otherButtonItems:yesButton, nil];
    [saveAlert show];
}

#pragma mark - Undo/Redo

- (IBAction)undo:(id)sender
{
    if(self.undoArray.count <= 1)
    {
        // Clear image
        self.mainImageView.image = NULL;
        
        // Clear array
        self.undoArray = [NSMutableArray array];
    }
    else
    {
        // Move back one stroke
        self.mainImageView.image = self.undoArray[self.undoArray.count - 2];
        
        // Remove stroke from array;
        [self.undoArray removeObjectAtIndex:self.undoArray.count - 2];
    }
    
    if([self peersConnected])
    {
        [self sendImage:self.mainImageView.image];
    }
}

#pragma mark - Line Options
- (void) changeLineWidth:(float)newLineWidth {
    self.currentLineWidth = newLineWidth;
}

- (void) changeOpacity:(float)newOpacity {
    self.currentOpacity = newOpacity;
}

- (IBAction)openOptions:(id)sender
{
    UIBarButtonItem *barButton = (UIBarButtonItem *)sender;
    OptionViewController *optVC = (OptionViewController *)self.optionsPopver.contentViewController;
    optVC.defaultLineValue = self.currentLineWidth;
    optVC.defaultOpacityValue = self.currentOpacity;
    [self.optionsPopver presentPopoverFromBarButtonItem:barButton permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (void)closeOptionsPopover
{
    [self.optionsPopver dismissPopoverAnimated:YES];
}

#pragma mark - Hide Status Bar & Lock Orientation
// Hides status bar (if possible)
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

// Lock Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helper Functions

- (BOOL)peersConnected
{
    return [self.mpcHandler.session.connectedPeers count];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
