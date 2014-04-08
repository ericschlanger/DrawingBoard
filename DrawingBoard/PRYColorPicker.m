#import "PRYColorPicker.h"
#import <CoreMotion/CoreMotion.h>

#define degrees(x) (180.0 * x / M_PI)

@interface PRYColorPicker ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation PRYColorPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        self.red = 0;
        self.green = 0;
        self.blue = 0;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    self.circleView.alpha = 1.0;
    self.circleView.layer.cornerRadius = self.frame.size.height/2;
    self.circleView.backgroundColor = [UIColor blackColor];

    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(holdAction:)];
    tapRecognizer.minimumPressDuration = 0;
    tapRecognizer.delegate = self;
    
    [self.circleView addGestureRecognizer:holdRecognizer];
    [self.circleView setUserInteractionEnabled:YES];
    
    [self addSubview:self.circleView];
}


#pragma mark - Core Motion Methods

-(void)detectMotion{
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
    
    float roll = degrees(attitude.roll);
    float pitch = degrees(attitude.pitch);
    float yaw = degrees(attitude.yaw);
    
    roll += 180;
    pitch += 180;
    yaw += 180;
    
    roll *= .6;
    pitch *= .6;
    yaw *= .6;
    
    self.circleView.backgroundColor = [UIColor colorWithRed:roll/255.0f green:pitch/255.0f blue:yaw/255.0f alpha:1];
    
    
    NSLog(@"roll = %f... pitch = %f ... yaw = %f", roll, pitch, yaw);
    
    
}

#pragma mark - Gesture recognizer delegate methods

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    
    if (holdRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|
                                                        UIViewAnimationOptionAllowUserInteraction
            animations:^{
                self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }
            completion:^(BOOL finished){
            }];
    }
    else if (holdRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|
                                                        UIViewAnimationOptionAllowUserInteraction
            animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
            completion:^(BOOL finished){
            }];
    }
    //[self detectMotion];
    
}


@end
