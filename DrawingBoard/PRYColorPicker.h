// Michael MacDougall, Eric Schlanger, Joe Canero, Lindsey Nice

#import <UIKit/UIKit.h>

@protocol PRYColorPickerDelegate <NSObject>

- (void)colorChangedToColor:(UIColor *)color;

@end

@interface PRYColorPicker : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;

@property (nonatomic, weak) id <PRYColorPickerDelegate> delegate;

@end
