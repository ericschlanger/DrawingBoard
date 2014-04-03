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
@end


@interface OptionViewController : UIViewController

- (IBAction)setLineWidth;
- (IBAction)closeWindow;

@property(nonatomic, weak) id delegate;
@property(nonatomic,strong) IBOutlet UISlider *slider;

@end
