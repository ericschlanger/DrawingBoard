//
//  OptionViewController.m
//  DrawingBoard
//
//  Created by Joseph Canero on 4/3/14.
//  Copyright (c) 2014 Eric Schlanger. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()


@end

@implementation OptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Initialize the sliders with the values passed in from the segue
    self.slider.value = self.defaultLineValue;
    self.opacSlider.value = self.defaultOpacityValue;
    
    [self updateLabels];
}

// change the opacity of the canvas
-(IBAction)setOpacity {
    self.opacLabel.text = [NSString stringWithFormat:@"%.2f", self.opacSlider.value];
    [self.delegate changeOpacity:self.opacSlider.value];
}

// change the line width of the canvas
-(IBAction)setLineWidth {
    self.lineLabel.text = [NSString stringWithFormat:@"%i", (int)self.slider.value];
    [self.delegate changeLineWidth:self.slider.value];
}

-(void)updateLabels {
    self.lineLabel.text = [NSString stringWithFormat:@"%i", (int)self.slider.value];
    self.opacLabel.text = [NSString stringWithFormat:@"%.2f", self.opacSlider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
