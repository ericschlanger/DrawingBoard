//
//  DMRNotificationView.h
//  notificationview
//
//  Created by Damir Tursunovic on 1/23/13.
//  Copyright (c) 2013 Damir Tursunovic (damir.me). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DMRNotificationViewDidTapHandler) ();

/** Predefined colors */
typedef NS_OPTIONS(NSUInteger, DMRNotificationViewType)
{
        DMRNotificationViewTypeDefault     = 0,        // Blue panel
        DMRNotificationViewTypeWarning     = 1,        // Red panel
        DMRNotificationViewTypeSuccess     = 2         // Green panel
};

@interface DMRNotificationView : UIView

/* Set this block to be notified when the user taps on the view. */
@property (nonatomic, copy) DMRNotificationViewDidTapHandler didTapHandler;

/* Predefined colors. Default is DMRNotificationViewTypeDefault (blue or custom) */
@property (nonatomic, assign) DMRNotificationViewType type;

/* Notification view tint color. Setter automatically sets 0.85 transparency (you can adjust transparency 
 by changing kNotificationViewTintColorTransparency).
 Default is [UIColor colorWithRed:0.384 green:0.486 blue:0.620 alpha:1.000]. */
@property (strong, nonatomic) UIColor *tintColor UI_APPEARANCE_SELECTOR;

/* Default is YES (0.85 opacity) */
@property (nonatomic, assign, setter = setIsTransparent:) BOOL transparent UI_APPEARANCE_SELECTOR;

/* Target view in which the notification will appear. Cannot be nil. */
@property (nonatomic, weak) UIView *targetView;

/* Title. Cannot be nil or 0 length. */
@property (strong, nonatomic) NSString *title;

/* Optional subtitle. */
@property (strong, nonatomic) NSString *subTitle;

/* The time interval which will cause the notification view to automatically dismiss it self. Set to 0.0 
 to disable auto dismiss. Default is 2.5. */
@property (nonatomic) NSTimeInterval hideTimeInterval;

/* Optional: custom fonts. */
@property (strong, nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;            // Default is [UIFont boldSystemFontOfSize:18.0]
@property (strong, nonatomic) UIFont *subTitleFont UI_APPEARANCE_SELECTOR;         // Default is [UIFont systemFontOfSize:15.0]

/**
 Default initializer. Target view is the view in which the notification view will appear. Use this method 
 if you want to customize the fonts, interval for dismiss and transparency.
 */
-(id)initWithTitle:(NSString *)title
          subTitle:(NSString *)subTitle
        targetView:(UIView *)view;

/**
 Convenience methods for quick use. Using one of these method does not allow you to customize the fonts, 
 interval for dismiss and transparency.
 */
+(void)showInView:(UIView *)view
            title:(NSString *)title
         subTitle:(NSString *)subTitle;

+(void)showInView:(UIView *)view
            title:(NSString *)title
         subTitle:(NSString *)subTitle
        tintColor:(UIColor *)tintColor;

+(void)showWarningInView:(UIView *)view
                 title:(NSString *)title
              subTitle:(NSString *)subTitle;

+(void)showSuccessInView:(UIView *)view
                 title:(NSString *)title
              subTitle:(NSString *)subTitle;

/**
 Shows the notification view from in target view. Slides the notification view from down if animated. 
 Position is always {0,0}.
 */
-(void)showAnimated:(BOOL)animated;

/**
 Dismisses the notification view. Slides the notification view up if animated.
 */
-(void)dismissAnimated:(BOOL)animated;

@end
