//
//  CanvasViewController.m
//  DrawingBoard
//
//  Created by Michael MacDougall on 3/29/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic) CGFloat currentLineWidth;
@property (nonatomic) CGFloat currentOpacity;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) BOOL swipe;

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
}


#pragma mark - Drawing/Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Assume no stroke movement
    self.swipe = NO;
    
    // Get touch position
    UITouch *lastTouch = [touches anyObject];
    self.lastPoint = [lastTouch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Set to true for movement
    self.swipe = YES;
    
    // Get current touch position
    UITouch *currentTouch = [touches anyObject];
    CGPoint currentPoint = [currentTouch locationInView:self.view];
    
    NSLog(@"Last Point: %f %f",self.lastPoint.x,self.lastPoint.y);
    NSLog(@"Current Point: %f %f",currentPoint.x,currentPoint.y);
    
    // Start graphics context with size of frame ***MAY HAVE TO CHANGE TO CANVAS/CURRENTIMAGE SIZE
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    // Draw from and to points
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
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
    [self.currentStrokeView performSelectorInBackground:@selector(setImage:) withObject:UIGraphicsGetImageFromCurrentImageContext()];
    [self.currentStrokeView setAlpha:self.currentOpacity];
    
    // End graphics context
    UIGraphicsEndImageContext();
    
    // Store last point
    self.lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.swipe)
    {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.currentLineWidth);
        
        // Get & set color components from UIColor
        CGFloat red = 0, green = 0, blue = 0;
        [self.currentColor getRed:&red green:&green blue:&blue alpha:nil];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, self.currentOpacity);
        
        // Draw single point
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        [self.currentStrokeView performSelectorInBackground:@selector(setImage:) withObject:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
    }
    
#warning Merging code not working right (slight movement)
    // Merge stroke view with main image view
    /*
    UIGraphicsBeginImageContext(self.mainImageView.frame.size);
    [self.mainImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.currentStrokeView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:self.currentOpacity];
    self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.currentStrokeView.image = nil;
    UIGraphicsEndImageContext();
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
