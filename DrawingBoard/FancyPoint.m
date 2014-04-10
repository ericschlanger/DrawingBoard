//
//  FancyPoint.m
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/10/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "FancyPoint.h"

@implementation FancyPoint

- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(int)width andOpacity:(CGFloat)opacity
{
    self = [super init];
    if(self)
    {
        self.x = point.x;
        self.y = point.y;
        CGFloat red,green,blue;
        [color getRed:&red green:&green blue:&blue alpha:nil];
        self.rColor = red;
        self.gColor = green;
        self.bColor = blue;
        self.opacity = opacity;
        self.lineWidth = width;
    }
    return self;
}

- (id)initFromString:(NSString *)string
{
    self = [super init];
    if(self)
    {
        NSArray *comp = [string componentsSeparatedByString:@"|"];
        self.x = [comp[0] intValue];
        self.y = [comp[1] intValue];
        self.rColor = [comp[2] intValue];
        self.gColor = [comp[3] intValue];
        self.bColor = [comp[4] intValue];
        self.opacity = [comp[5] floatValue];
        self.lineWidth = [comp[6] intValue];
    }
    return self;
}

- (NSString *)toString
{
    NSString *returnString = [NSString stringWithFormat:@"%d|%d|%d|%d|%d|%f|%d",self.x,self.y,self.rColor,self.gColor,self.bColor,self.opacity,self.lineWidth];
    return returnString;
}

@end
