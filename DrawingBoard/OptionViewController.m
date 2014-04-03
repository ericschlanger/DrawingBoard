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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the sliders with the values passed in from the segue
    self.slider.value = self.defaultLineValue;
    self.opacSlider.value = self.defaultOpacityValue;
    [self updateLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

-(IBAction)closeWindow {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateLabels {
    self.lineLabel.text = [NSString stringWithFormat:@"%i", (int)self.slider.value];
    self.opacLabel.text = [NSString stringWithFormat:@"%.2f", self.opacSlider.value];
}

@end
