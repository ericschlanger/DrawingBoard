
#import "CanvasViewController.h"


@interface CanvasViewController ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic) CGFloat currentLineWidth;
@property (nonatomic) CGFloat currentOpacity;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint lastPointReceived;

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
    
    self.lastPointReceived = CGPointZero;
    
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

-(void)sendCGPoint:(CGPoint)point{
    
    NSData *data = [NSStringFromCGPoint(point) dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    //NSLog(@"Connected Peers array: %@", self.mpcHandler.session.connectedPeers);
    
    [self.mpcHandler.session sendData:data toPeers:self.mpcHandler.session.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
    if(error != NULL)
    {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (IBAction)sendData:(id)sender {
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self.mpcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveData:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSData *recData = userInfo[@"data"];
    NSString *dataString = [NSString stringWithUTF8String:[recData bytes]];
    CGPoint receivedPoint = CGPointFromString(dataString);
    
    if(CGPointEqualToPoint(self.lastPointReceived, CGPointZero))
    {
        [self drawLineFromPoint:receivedPoint toPoint:receivedPoint];
    }
    else
    {
        [self drawLineFromPoint:self.lastPointReceived toPoint:receivedPoint];
    }
    self.lastPointReceived = receivedPoint;
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
    
    [self sendCGPoint:self.lastPoint];
    
    // Get current touch position
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self.currentStrokeView];
    
    [self drawLineFromPoint:self.lastPoint toPoint:currentPoint];
    
    // Store last point
    self.lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.swipe)
    {
        [self drawLineFromPoint:self.lastPoint toPoint:self.lastPoint];
    }
    [self mergeStrokesToMainImage];
}

#pragma mark - Drawing
- (void)drawLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    // Start graphics context with size of frame
    UIGraphicsBeginImageContext(self.currentStrokeView.frame.size);
    
    // Draw from and to points
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.currentStrokeView.frame.size.width,self.currentStrokeView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point1.x, point1.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point2.x, point2.y);
    
    // Set line parameters
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.currentLineWidth);
    
    // Get & set color components from UIColor
    CGFloat red = 0, green = 0, blue = 0;
    [self.currentColor getRed:&red green:&green blue:&blue alpha:nil];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    // Draw image to stroke view
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    [self.currentStrokeView setImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    [self.currentStrokeView setAlpha:self.currentOpacity];
    
    // End graphics context
    UIGraphicsEndImageContext();
}

- (void)mergeStrokesToMainImage
{
    // Merge stroke view with main image view
    UIGraphicsBeginImageContext(self.mainImageView.frame.size);
    [self.mainImageView.image drawInRect:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.mainImageView.frame.size.width, self.mainImageView.frame.size.height) blendMode:kCGBlendModeNormal alpha:self.currentOpacity];
    
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
