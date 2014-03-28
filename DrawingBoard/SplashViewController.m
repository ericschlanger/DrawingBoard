//
//  SplashViewController.m
//  DrawingBoard
//
//  Created by Eric Schlanger on 3/27/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "SplashViewController.h"
#import <CoreText/CoreText.h>

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupTextLayer{
    
    if (self.textPathLayer != nil) {
        [self.textPathLayer removeFromSuperlayer];
        self.textPathLayer = nil;
    }
    
    // Create path from text
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("ChalkboardSE-Bold"), 72.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Hello World!"
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++){
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++){
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *textPathLayer = [CAShapeLayer layer];
    textPathLayer.frame = self.textAnimationLayer.bounds;
	textPathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    //textPathLayer.backgroundColor = [[UIColor yellowColor] CGColor];
    textPathLayer.geometryFlipped = YES;
    textPathLayer.path = path.CGPath;
    textPathLayer.strokeColor = [[UIColor blackColor] CGColor];
    textPathLayer.fillColor = nil;
    textPathLayer.lineWidth = 3.0f;
    textPathLayer.lineJoin = kCALineJoinBevel;
    
    [self.textAnimationLayer addSublayer:textPathLayer];
    
    self.textPathLayer = textPathLayer;
    
}

- (void) setupDrawingLayer
{
    if (self.eraserPathLayer != nil) {
        [self.eraserPathLayer removeFromSuperlayer];
        self.eraserPathLayer = nil;
    }
    
    CGPoint startPoint 	= CGPointMake(20,30);
    CGPoint pointTwo	= CGPointMake(50,70);
    CGPoint pointThree  = CGPointMake(20,200);
    CGPoint pointFour	= CGPointMake(150,150);
    CGPoint endPoint	= CGPointMake(40,60);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:pointTwo];
    [path addLineToPoint:pointThree];
    [path addLineToPoint:pointFour];
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.eraserAnimationLayer.bounds;
    pathLayer.bounds = CGRectMake(20, 150, 130, 120);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 20.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.eraserAnimationLayer addSublayer:pathLayer];
    
    self.eraserPathLayer = pathLayer;
    
}

- (void) startAnimation{
    [self.eraserPathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.eraserPathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

- (void) startTextAnimation{
    [self.textPathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.textPathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eraserAnimationLayer = [CALayer layer];
    self.eraserAnimationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.eraserAnimationLayer];
    
    self.textAnimationLayer = [CALayer layer];
    self.textAnimationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.textAnimationLayer];
    
    [self setupTextLayer];
    [self setupDrawingLayer];
    [self startTextAnimation];
    [self startAnimation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
