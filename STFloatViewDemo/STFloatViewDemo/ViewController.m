//
//  ViewController.m
//  STFloatViewDemo
//
//  Created by admin on 2021/4/12.
//

#import "ViewController.h"
#import "UIViewController+STFloatView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didClickOnSample1:(id)sender {
    [self presentFloatImage:[UIImage imageNamed:@"bonus"] withOptions:@{        STFloatViewOptionKeys.animationDuration:@(0.6),
        STFloatViewOptionKeys.enableCountDown:@(YES),
        STFloatViewOptionKeys.countDownSeconds:@(10),
        STFloatViewOptionKeys.isWindowLevel:@(YES),
        STFloatViewOptionKeys.enablePanGesture:@(YES),
        STFloatViewOptionKeys.enableClose:@(YES),
        STFloatViewOptionKeys.closeBtnImageName:@"close",
        STFloatViewOptionKeys.closeBtnBaseOnLeft:@(YES),
    } clickBlock:^{
            ;
    }];
}

- (IBAction)didClickOnSample2:(id)sender {
    [self presentFloatImage:[UIImage imageNamed:@"bonus"] withOptions:@{        STFloatViewOptionKeys.animationDuration:@(0.6),
        STFloatViewOptionKeys.enableCountDown:@(YES),
        STFloatViewOptionKeys.countDownSeconds:@(10),
        STFloatViewOptionKeys.isWindowLevel:@(YES),
        STFloatViewOptionKeys.enablePanGesture:@(YES),
        STFloatViewOptionKeys.enableClose:@(YES),
        STFloatViewOptionKeys.closeBtnImageName:@"close",
        STFloatViewOptionKeys.closeBtnBaseOnLeft:@(YES),
                                                                                
        STFloatViewOptionKeys.origalImageWidth:@(50),
        STFloatViewOptionKeys.origalImageHeight:@(50),
        STFloatViewOptionKeys.stopImageWidth:@(100),
        STFloatViewOptionKeys.stopImageHeight:@(100),
        STFloatViewOptionKeys.finalImageWidth:@(50),
        STFloatViewOptionKeys.finalImageHeight:@(50),
    } clickBlock:^{
        
    }];
}

- (IBAction)didClickOnSample3:(id)sender {
    [self presentFloatImage:[UIImage imageNamed:@"bonus"] withOptions:@{        STFloatViewOptionKeys.animationDuration:@(0.6),
        STFloatViewOptionKeys.enableCountDown:@(YES),
        STFloatViewOptionKeys.countDownSeconds:@(10),
        STFloatViewOptionKeys.isWindowLevel:@(YES),
        STFloatViewOptionKeys.enablePanGesture:@(YES),
        STFloatViewOptionKeys.enableClose:@(YES),
        STFloatViewOptionKeys.closeBtnImageName:@"close",
        STFloatViewOptionKeys.closeBtnBaseOnLeft:@(NO),
                                                                                
        STFloatViewOptionKeys.origalImageWidth:@(50),
        STFloatViewOptionKeys.origalImageHeight:@(50),
        STFloatViewOptionKeys.stopImageWidth:@(100),
        STFloatViewOptionKeys.stopImageHeight:@(100),
        STFloatViewOptionKeys.finalImageWidth:@(50),
        STFloatViewOptionKeys.finalImageHeight:@(50),
                                                                                
        STFloatViewOptionKeys.origalFrameX:@(0),
        STFloatViewOptionKeys.origalFrameY:@(200),
        STFloatViewOptionKeys.stopFrameX:@(100),
        STFloatViewOptionKeys.stopFrameY:@(200),
        STFloatViewOptionKeys.finalFrameX:@(0),
        STFloatViewOptionKeys.finalFrameY:@(300),

    } clickBlock:^{
            ;
    }];
}

@end
