//
//  FancyPoint.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/10/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//
// Michael MacDougall, Eric Schlanger, Joe Canero, Lindsey Nice


#import <Foundation/Foundation.h>

@interface FancyPoint : NSObject

@property (nonatomic)short x;
@property (nonatomic)short y;
@property (nonatomic)short rColor;
@property (nonatomic)short gColor;
@property (nonatomic)short bColor;
@property (nonatomic)short lineWidth;
@property (nonatomic)short opacity;
@property (nonatomic)short strokeID;

// Initialize with attributes
- (id)initWithPoint:(CGPoint)point andColor:(UIColor *)color andWidth:(char)width andOpacity:(float)opacity andID:(short)strokeID;

// Initialize from string
- (id)initFromString:(NSString *)string;

// Generate string
- (NSString *)toString;

// Get color as UIColor
- (UIColor *)fetchColor;

// Get opacity as CGFloat
- (CGFloat)fetchOpacity;

@end
