#import "PRYColorPicker.h"
#import <CoreMotion/CoreMotion.h>

#define degrees(x) (180.0 * x / M_PI)

@interface PRYColorPicker ()

@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSTimer *timer;

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
    
    [self.circleView addGestureRecognizer:tapRecognizer];
    [self.circleView setUserInteractionEnabled:YES];
    
    [self addSubview:self.circleView];
}


#pragma mark - Core Motion Methods

-(void)beginDetectingMotion{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0/60.0; //60 Hz
    [self.motionManager startDeviceMotionUpdates];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0)
                                                      target:self
                                                    selector:@selector( readIt )
                                                    userInfo:nil
                                                     repeats:YES];
    
    [self.timer fire];
}


- (void) readIt {
    
    CMAttitude *attitude;
    
    CMDeviceMotion *motion = self.motionManager.deviceMotion;
    if (!motion) {
        return;
    }
    
    attitude = motion.attitude;
    
    float pitch = degrees(attitude.pitch);
    float roll = degrees(attitude.roll);
    float yaw = degrees(attitude.yaw);
    
    pitch += 180;
    roll += 180;
    yaw += 180;
    
    self.circleView.backgroundColor = [UIColor colorWithRed:[self rgbValueFromAttitude:pitch]/255.0f
                                                      green:[self rgbValueFromAttitude:roll]/255.0f
                                                       blue:[self rgbValueFromAttitude:yaw]/255.0f alpha:1];
}

-(void)stopDetectingMotion{
    [self.timer invalidate];
    [self.delegate colorChangedToColor:self.circleView.backgroundColor];
}


#pragma mark - Gesture recognizer delegate methods

- (void)holdAction:(UILongPressGestureRecognizer *)holdRecognizer
{
    
    if (holdRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self beginDetectingMotion];
        
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
        [self stopDetectingMotion];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|
                                                        UIViewAnimationOptionAllowUserInteraction
            animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
            completion:^(BOOL finished){
            }];
    
    
    }
}

#pragma mark - Helper Methods

-(float)rgbValueFromAttitude:(float)attitude{
    
    float result = 0;
    
    if(attitude < 90){
        result = 0;
    }
    else if (attitude > 90 && attitude < 270){
        attitude -= 90;
        result = attitude * (255 / 180);
    }
    else{
        result = 255;
    }
    
    return result;
    
}

@end
