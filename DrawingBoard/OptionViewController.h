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
- (void)updateLabels;

@property(nonatomic, weak) id delegate;
@property(nonatomic, strong) IBOutlet UISlider *slider;
@property(nonatomic, strong) IBOutlet UISlider *opacSlider;
@property(nonatomic, strong) IBOutlet UILabel *lineLabel;
@property(nonatomic, strong) IBOutlet UILabel *opacLabel;
@property(nonatomic) float defaultLineValue;
@property(nonatomic) float defaultOpacityValue;

@end
