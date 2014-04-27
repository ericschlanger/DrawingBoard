//
//  OptionViewController.h
//  DrawingBoard
//
//  Created by Joseph Canero on 4/3/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"
// Michael MacDougall, Eric Schlanger, Joe Canero, Lindsey Nice

// Protocol methods
@protocol ChangeOptionsDelegate <NSObject>
- (void)changeLineWidth:(float) newLineWidth;
- (void)changeOpacity:(float) newOpacity;
- (void)closeOptions;
@end


@interface OptionViewController : UIViewController

// IBActions for options popover
- (IBAction)setLineWidth;
- (IBAction)setOpacity;
- (IBAction)close:(id)sender;

// Delegate
@property(nonatomic, weak) id delegate;
@property(nonatomic) float defaultLineValue;
@property(nonatomic) float defaultOpacityValue;

// IBOulets
@property(nonatomic, strong) IBOutlet UISlider *slider;
@property(nonatomic, strong) IBOutlet UISlider *opacSlider;
@property(nonatomic, strong) IBOutlet UILabel *lineLabel;
@property(nonatomic, strong) IBOutlet UILabel *opacLabel;


@end
