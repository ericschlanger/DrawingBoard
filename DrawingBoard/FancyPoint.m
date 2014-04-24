//
//  FancyPoint.m
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/10/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "FancyPoint.h"

@implementation FancyPoint

- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(char)width andOpacity:(float)opacity andID:(short)strokeID
{
    self = [super init];
    if(self)
    {
        self.x = point.x;
        self.y = point.y;
        CGFloat red,green,blue;
        [color getRed:&red green:&green blue:&blue alpha:nil];
        self.rColor = red * 255.0f;
        self.gColor = green * 255.0f;
        self.bColor = blue * 255.0f;
        self.opacity = opacity * 100;
        self.lineWidth = width;
        self.strokeID = strokeID;
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
        self.opacity = [comp[5] intValue];
        self.lineWidth = [comp[6] intValue];
        self.strokeID = [comp[7] intValue];
    }
    return self;
}

- (NSString *)toString
{
    NSString *returnString = [NSString stringWithFormat:@"%hd|%hd|%hd|%hd|%hd|%hd|%hd|%hd",self.x,self.y,self.rColor,self.gColor,self.bColor,self.opacity,self.lineWidth,self.strokeID];
    return returnString;
}

- (UIColor *)fetchColor
{
    return [UIColor colorWithRed:(self.rColor/255.0f) green:(self.gColor/255.0f) blue:(self.bColor/255.0f) alpha:1];
}

- (CGFloat)fetchOpacity
{
    return self.opacity / 100.0f;
}

@end
