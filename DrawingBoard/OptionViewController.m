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


-(IBAction)setLineWidth {
    NSLog(@"here!");
    /*if([self.delegate respondsToSelector:@selector(changeLineWidth:)]) {
        NSLog(@"Inside!");
        [_delegate changeLineWidth:slider.value];
    }*/
    [self.delegate changeLineWidth:self.slider.value];
}

-(IBAction)closeWindow {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
