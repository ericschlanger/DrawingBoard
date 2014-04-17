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
        self.rColor = (char)((red * 255.0f) - 128);
        self.gColor = (char)((green * 255.0f) - 128);
        self.bColor = (char)((blue * 255.0f) - 128);
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
        self.x = (short)[comp[0] intValue];
        self.y = (short)[comp[1] intValue];
        self.rColor = (char)[comp[2] intValue];
        self.gColor = (char)[comp[3] intValue];
        self.bColor = (char)[comp[4] intValue];
        self.opacity = (char)[comp[5] intValue];
        self.lineWidth = (char)[comp[6] intValue];
        self.strokeID = (short)[comp[7] intValue];
    }
    return self;
}

- (NSString *)toString
{
    NSString *returnString = [NSString stringWithFormat:@"%hd|%hd|%d|%d|%d|%d|%d|%hd",self.x,self.y,self.rColor,self.gColor,self.bColor,self.opacity,self.lineWidth,self.strokeID];
    return returnString;
}

- (UIColor *)fetchColor
{
    return [UIColor colorWithRed:(self.rColor+128)/255.0f green:(self.gColor+128)/255.0f blue:(self.bColor+128)/255.0 alpha:1];
}

- (CGFloat)fetchOpacity
{
    return self.opacity / 100.0f;
}

@end
