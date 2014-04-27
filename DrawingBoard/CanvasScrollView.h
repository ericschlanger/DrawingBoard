//
//  CanvasScrollView.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 4/16/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//
// Michael MacDougall, Eric Schlanger, Joe Canero, Lindsey Nice

#import <UIKit/UIKit.h>

@interface CanvasScrollView : UIScrollView

// Next responder used for passing touch events (CanvasViewController)
@property (nonatomic, strong) IBOutlet UIResponder *imageNextResponder;

@end
