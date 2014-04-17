#import "SplashViewController.h"
#import <CoreText/CoreText.h>

@interface SplashViewController ()

@property (nonatomic, strong) CALayer *eraserAnimationLayer;
@property (nonatomic, strong) CAShapeLayer *eraserPathLayer;
@property (nonatomic, strong) CALayer *textAnimationLayer;
@property (nonatomic, strong) CAShapeLayer *textPathLayer;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textAnimationLayer = [CALayer layer];
    self.textAnimationLayer.frame = CGRectMake(20.0f, 20.0f,
                                               CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                               CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.textAnimationLayer];
    
    self.eraserAnimationLayer = [CALayer layer];
    self.eraserAnimationLayer.frame = CGRectMake(20.0f, 64.0f,
                                                 CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                                 CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.eraserAnimationLayer];
    
    [self startTextAnimation];
    
}

#pragma mark - Animation Setup Methods

- (void) setupTextLayer{
    
    if (self.textPathLayer != nil) {
        [self.textPathLayer removeFromSuperlayer];
        self.textPathLayer = nil;
    }
    
    // Create path from text
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        font = CTFontCreateWithName(CFSTR("ChalkboardSE-Bold"), 100.0f, NULL);
    }
    else
    {
        font = CTFontCreateWithName(CFSTR("ChalkboardSE-Bold"), 45.0f, NULL);
    }
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"DrawingBoard"
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
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, nil);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    // Test
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *textPathLayer = [CAShapeLayer layer];
    textPathLayer.frame = self.textAnimationLayer.bounds;
	textPathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    textPathLayer.geometryFlipped = YES;
    textPathLayer.path = path.CGPath;
    textPathLayer.strokeColor = [[UIColor blackColor] CGColor];
    textPathLayer.fillColor = nil;
    textPathLayer.lineWidth = 4.0f;
    textPathLayer.lineJoin = kCALineJoinRound;
    
    [self.textAnimationLayer addSublayer:textPathLayer];
    
    self.textPathLayer = textPathLayer;
    
}

- (void) setupEraserPathLayer{
    if (self.eraserPathLayer != nil) {
        [self.eraserPathLayer removeFromSuperlayer];
        self.eraserPathLayer = nil;
    }
    
    CGPoint startPoint,pointTwo,pointThree,pointFour,pointFive,pointSix,endPoint;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        startPoint 	= CGPointMake(30,160);
        pointTwo	= CGPointMake(140,220);
        pointThree  = CGPointMake(265,160);
        pointFour	= CGPointMake(380,220);
        pointFive	= CGPointMake(500,160);
        pointSix	= CGPointMake(620,220);
        endPoint	= CGPointMake(740,160);
    }
    else
    {
        startPoint 	= CGPointMake(30,160);
        pointTwo	= CGPointMake(60,220);
        pointThree  = CGPointMake(145,160);
        pointFour	= CGPointMake(165,220);
        pointFive	= CGPointMake(220,160);
        pointSix	= CGPointMake(240,220);
        endPoint	= CGPointMake(320,160);
    }
    
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:pointTwo];
    [path addLineToPoint:pointThree];
    [path addLineToPoint:pointFour];
    [path addLineToPoint:pointFive];
    [path addLineToPoint:pointSix];
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.eraserAnimationLayer.bounds;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        pathLayer.bounds = CGRectMake(0, 0, 768, 480);
    }
    else
    {
        pathLayer.bounds = CGRectMake(0, 0, 320, 480);
    }
    //pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    pathLayer.fillColor = nil;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        pathLayer.lineWidth = 110.0f;
    }
    else
    {
        pathLayer.lineWidth = 70.0f;
    }
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.eraserAnimationLayer addSublayer:pathLayer];
    
    self.eraserPathLayer = pathLayer;
    
}

#pragma mark - Animation Start Methods

- (void) startEraserAnimation{
    
    [self setupEraserPathLayer];
    
    [self.eraserPathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.delegate = self;
    [pathAnimation setValue:@"eraser" forKey:@"id"];
    [self.eraserPathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}

- (void) startTextAnimation{
    
    [self setupTextLayer];
    
    [self.textPathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.delegate = self;
    [pathAnimation setValue:@"text" forKey:@"id"];
    [self.textPathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

#pragma mark - CAAnimation Delegate Methods

//Called when the text animation finishes
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if([[anim valueForKey:@"id"] isEqualToString:@"text"]){
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self startEraserAnimation];
        });
    }
    else if ([[anim valueForKey:@"id"] isEqualToString:@"eraser"]){
        [self performSegueWithIdentifier:@"splashDone" sender:self];
    }
}


@end
