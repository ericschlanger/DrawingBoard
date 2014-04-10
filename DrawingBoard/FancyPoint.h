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
@property (nonatomic)int rColor;
@property (nonatomic)int gColor;
@property (nonatomic)int bColor;
@property (nonatomic)int lineWidth;
@property (nonatomic)CGFloat opacity;

- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(int)width andOpacity:(CGFloat)opacity;
- (id)initFromString:(NSString *)string;
- (NSString *)toString;

@end
