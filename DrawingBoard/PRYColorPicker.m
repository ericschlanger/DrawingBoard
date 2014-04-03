#import "PRYColorPicker.h"
#import <CoreMotion/CoreMotion.h>

#define degrees(x) (180.0 * x / M_PI)

@interface PRYColorPicker ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation PRYColorPicker


-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        
        self.red = 0;
        self.green = 0;
        self.blue = 0;
    
    }
    
    return self;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    self.circleView.alpha = 1.0;
    self.circleView.layer.cornerRadius = 25;
    self.circleView.backgroundColor = [UIColor blackColor];

    UILongPressGestureRecognizer *holdRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(holdAction:)];
    holdRecognizer.delegate = self;
    holdRecognizer.minimumPressDuration = .05;
    
    [self.circleView addGestureRecognizer:holdRecognizer];
    [self.circleView setUserInteractionEnabled:YES];
    
    [self addSubview:self.circleView];
}


#pragma mark - Core Motion Methods

-(void)motion{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0/60.0; //60 Hz
    [self.motionManager startDeviceMotionUpdates];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0)
                                                      target:self
                                                    selector:@selector( readIt )
                                                    userInfo:nil
                                                     repeats:YES];
    
    [timer fire];
}


- (void) readIt {
    
    //  CMAttitude *referenceAttitude;
    CMAttitude *attitude;
    
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (!motion) {
        return;
    }
    
    attitude = motion.attitude;
    
    NSLog(@"roll = %f... pitch = %f ... yaw = %f", degrees(attitude.roll), degrees(attitude.pitch), degrees(attitude.yaw));
    
    
}

#pragma mark - Gesture recognizer delegate methods

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    if (holdRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"holding");
    } else if (holdRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"You let go!");
    }
}


@end
