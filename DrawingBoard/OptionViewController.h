//
//  OptionViewController.h
//  DrawingBoard
//
//  Created by Joseph Canero on 4/3/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeOptionsDelegate <NSObject>
- (void)changeLineWidth:(float) newLineWidth;
- (void)changeOpacity:(float) newOpacity;
@end


@interface OptionViewController : UIViewController

- (IBAction)setLineWidth;
- (IBAction)setOpacity;
- (IBAction)closeWindow;
- (void)updateLabels;

@property(nonatomic, weak) id delegate;
@property(nonatomic, weak) IBOutlet UISlider *slider;
@property(nonatomic, weak) IBOutlet UISlider *opacSlider;
@property(nonatomic, weak) IBOutlet UILabel *lineLabel;
@property(nonatomic, weak) IBOutlet UILabel *opacLabel;
@property(nonatomic) float defaultLineValue;
@property(nonatomic) float defaultOpacityValue;

@end
