//
//  FancyPoint.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/10/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FancyPoint : NSObject

@property (nonatomic)int x;
@property (nonatomic)int y;
@property (nonatomic)float rColor;
@property (nonatomic)float gColor;
@property (nonatomic)float bColor;
@property (nonatomic)int lineWidth;
@property (nonatomic)float opacity;

- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(int)width andOpacity:(float)opacity;
- (id)initFromString:(NSString *)string;
- (NSString *)toString;

@end
