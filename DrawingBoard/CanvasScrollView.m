//
//  CanvasScrollView.m
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/16/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "CanvasScrollView.h"

@implementation CanvasScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // Removes touch delay
        self.delaysContentTouches = NO;
        
        // Only respond to two finger gestures
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            if([gesture isKindOfClass:[UIPanGestureRecognizer class]])
            {
                UIPanGestureRecognizer *panRec = (UIPanGestureRecognizer *)gesture;
                panRec.minimumNumberOfTouches = 2;
            }
        }
    }
    return self;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.delaysContentTouches = NO;
    if([event.allTouches count] == 1)
    {
        [self.imageNextResponder touchesBegan:touches withEvent:event];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([event.allTouches count] == 1)
    {
        [self.imageNextResponder touchesMoved:touches withEvent:event];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([event.allTouches count] == 1)
    {
        [self.imageNextResponder touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([event.allTouches count] == 1)
    {
        [self.imageNextResponder touchesCancelled:touches withEvent:event];
    }
}

@end
