
#import "CanvasViewController.h"


@interface CanvasViewController ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic) CGFloat currentLineWidth;
@property (nonatomic) CGFloat currentOpacity;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) FancyPoint *lastPointReceived;

@property (nonatomic) BOOL swipe;

@property (nonatomic, strong) MPCHandler *mpcHandler;

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
    
    // Temporary Settings
    self.currentColor = [UIColor blackColor];
    self.currentLineWidth = 10.0f;
    self.currentOpacity = 1.0;
    self.lastPoint = CGPointMake(0, 0);
    
    self.panScrollView.delegate = self;
    
    
    // Ensure that scrollview only allows two-finger scrolling
    for (UIGestureRecognizer *gesture in self.panScrollView.gestureRecognizers)
    {
        if([gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *panRec = (UIPanGestureRecognizer *)gesture;
            panRec.minimumNumberOfTouches = 2;
        }
    }
    
    // Initialize MCPHandler
    self.mpcHandler = [[MPCHandler alloc]init];
    NSString *randUser = [NSString stringWithFormat:@"User%d",arc4random()];
    [self.mpcHandler setupPeerWithDisplayName:randUser];
    [self.mpcHandler setupSession];
    [self.mpcHandler advertiseSelf:true];
    
    PRYColorPicker *colorPicker = [[PRYColorPicker alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height-125, 50, 50)];
    [self.view addSubview:colorPicker];
    
    // Handle Notifcations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveData:)
                                                 name:@"DrawingBoard_ReceivedData"
                                               object:nil];
    
    self.lastPointReceived = NULL;
    
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

- (void)sendCGPoint:(FancyPoint *)point andIsLastPoint:(BOOL)isLast
{
    if(!isLast)
    {
        NSData *data = [[point toString] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        
        [self.mpcHandler.session sendData:data toPeers:self.mpcHandler.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
        if(error != NULL)
        {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
    else
    {
        NSString *end = @"End";
        NSData *data = [end dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        [self.mpcHandler.session sendData:data toPeers:self.mpcHandler.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
        if(error != NULL)
        {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)didReceiveData:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSData *recData = userInfo[@"data"];
    NSString *dataString = [NSString stringWithUTF8String:[recData bytes]];
    if(dataString != NULL)
    {
        if([dataString isEqualToString:@"End"])
        {
            [self mergeStrokesToMainImageWithOpacity:self.lastPointReceived.opacity];
            self.lastPointReceived = NULL;
        }
        else
        {
            FancyPoint *point = [[FancyPoint alloc]initFromString:dataString];
            UIColor *color = [UIColor colorWithRed:point.rColor/255.0f green:point.gColor/255.0f blue:point.bColor/255.0f alpha:1];
            //UIColor *color = [UIColor blackColor];
            
            if(self.lastPointReceived == NULL)
            {
                [self drawLineFromPoint:CGPointMake(point.x, point.y) toPoint:CGPointMake(point.x, point.y) withColor:color andWidth:point.lineWidth andOpacity:point.opacity];
            }
            else
            {
                [self drawLineFromPoint:CGPointMake(self.lastPointReceived.x,self.lastPointReceived.y) toPoint:CGPointMake(point.x, point.y) withColor:color andWidth:point.lineWidth andOpacity:point.opacity];
            }
            self.lastPointReceived = point;
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Set to true for movement
    self.swipe = YES;
    
    if([self.mpcHandler.session.connectedPeers count] > 0)
    {
        FancyPoint *fancyPoint = [[FancyPoint alloc]initWithPoint:self.lastPoint andColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity];
        [self sendCGPoint:fancyPoint andIsLastPoint:NO];
    }
    
    // Get current touch position
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self.currentStrokeView];
    
    [self drawLineFromPoint:self.lastPoint toPoint:currentPoint withColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity];
    
    // Store last point
    self.lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.swipe)
    {
        [self drawLineFromPoint:self.lastPoint toPoint:self.lastPoint withColor:self.currentColor andWidth:self.currentLineWidth andOpacity:self.currentOpacity];
    }
    
    if([self.mpcHandler.session.connectedPeers count] > 0)
    {

        [self sendCGPoint:NULL andIsLastPoint:YES];
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
    
}

#pragma mark - Line Options
- (void) changeLineWidth:(float)newLineWidth {
    self.currentLineWidth = newLineWidth;
}

- (void) changeOpacity:(float)newOpacity {
    self.currentOpacity = newOpacity;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"openOptions"])
    {
        OptionViewController *optionVC = [segue destinationViewController];
        optionVC.delegate = self;
        optionVC.defaultLineValue = self.currentLineWidth;      // pass in initial values for sliders
        optionVC.defaultOpacityValue = self.currentOpacity;
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
