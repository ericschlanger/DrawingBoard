//
//  CanvasViewController.h
//  DrawingBoard
//
//  Created by Michael MacDougall on 3/29/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionViewController.h"
#import "MPCHandler.h"

@interface CanvasViewController : UIViewController <UIScrollViewDelegate, ChangeOptionsDelegate>


// UIImageView for entire image with all strokes merged
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;

// UIImageView for current stroke
@property (nonatomic, strong) IBOutlet UIImageView *currentStrokeView;


@property (nonatomic, strong) IBOutlet UIScrollView *panScrollView;

- (IBAction)connect:(id)sender;

@end
