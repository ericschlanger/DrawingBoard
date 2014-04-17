//
//  FancyPoint.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/10/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FancyPoint : NSObject

@property (nonatomic)short x;
@property (nonatomic)short y;
@property (nonatomic)char rColor;
@property (nonatomic)char gColor;
@property (nonatomic)char bColor;
@property (nonatomic)char lineWidth;
@property (nonatomic)short opacity;
@property (nonatomic)short strokeID;

- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(char)width andOpacity:(float)opacity andID:(short)strokeID;
- (id)initFromString:(NSString *)string;
- (NSString *)toString;

- (UIColor *)fetchColor;
- (CGFloat)fetchOpacity;

@end
