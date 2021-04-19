//
//  UIViewController+STFloatView.m
//
//  Created by admin on 2021/1/28.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void (^ActionBlock)(void);
@interface UIButton (STBlock)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;
@end

@implementation UIButton (STBlock)
static char eventKey;
- (void)handleControlEvent:(UIControlEvents)event withBlock:(void (^)(void))action {
     objc_setAssociatedObject(self, &eventKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
     [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}
- (void)callActionBlock:(id)sender {
     ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &eventKey);
     if (block) {
         block();
     }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint p = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, p)) {
                view = subView;
            }
        }
    }
    return view;
}
@end


#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject (STFloatViewRegister)

static char const * const STFloatViewRegisterOption = "STFloatViewRegisterOption";
static char const * const STFloatViewDefaultOption = "STFloatViewDefaultOption";

- (void)stFloatView_registerOptions:(NSDictionary *)options
                  defaults:(NSDictionary *)defaults {
    objc_setAssociatedObject(self, STFloatViewRegisterOption, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, STFloatViewDefaultOption, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)stFloatView_optionOrDefaultForKey:(NSString*)optionKey {
    NSDictionary *options = objc_getAssociatedObject(self, STFloatViewRegisterOption);
    NSDictionary *defaults = objc_getAssociatedObject(self, STFloatViewDefaultOption);
    return options[optionKey] ?: defaults[optionKey];
}
@end


#import "UIViewController+STFloatView.h"

const struct STFloatViewOptionKeys STFloatViewOptionKeys = {
    .animationDuration       = @"STFloatViewOptionAnimationDuration",
    
    .enableCountDown         = @"STFloatViewOptionEnableCountDown",
    .countDownSeconds        = @"STFloatViewOptionCountDownSeconds",
    
    .isWindowLevel           = @"STFloatViewOptionisWindowLevel",
    .enablePanGesture        = @"STFloatViewOptionEnablePanGesture",
    
    .enableClose             = @"STFloatViewOptionEnableClose",
    .closeBtnImageName       = @"STFloatViewOptionCloseBtnImageName",
    .closeBtnBaseOnLeft      = @"STFloatViewOptionCloseBtnBaseOnLeft",
    
    .origalImageWidth        = @"STFloatViewOptionOrigalImageWidth",
    .origalImageHeight       = @"STFloatViewOptionOrigalImageHeight",
    .stopImageWidth          = @"STFloatViewOptionStopImageWidth",
    .stopImageHeight         = @"STFloatViewOptionStopImageHeight",
    .finalImageWidth         = @"STFloatViewOptionFinalImageWidth",
    .finalImageHeight        = @"STFloatViewOptionFinalImageHeight",
    
    .origalFrameX            = @"STFloatViewOptionOrigalFrameX",
    .origalFrameY            = @"STFloatViewOptionOrigalFrameY",
    .stopFrameX              = @"STFloatViewOptionStopFrameX",
    .stopFrameY              = @"STFloatViewOptionStopFrameY",
    .finalFrameX             = @"STFloatViewOptionFinalFrameX",
    .finalFrameY             = @"STFloatViewOptionFinalFrameY"
};

#define kFloatBtnTag                10001
#define kcountDownLabelTag          10002

#define CountDownLabelBgColor       [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define CountDownLabelTextColor     [UIColor whiteColor]
#define CountDownLabelCornerRadius  10
#define CountDownLabelFont          [UIFont systemFontOfSize:12];


@implementation UIViewController (STFloatView)

-(UIView*)stFloatView_parentTarget {
    UIViewController * targetVC = self;
    if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.isWindowLevel] boolValue]) {
        while (targetVC.parentViewController != nil) {
            targetVC = targetVC.parentViewController;
        }
    }
    return targetVC.view;
}

-(void)stFloatView_registerDefaultsAndOptions:(NSDictionary*)options {
    [self stFloatView_registerOptions:options defaults:@{
        STFloatViewOptionKeys.animationDuration:@(0.6),
        STFloatViewOptionKeys.enableCountDown:@(NO),
        STFloatViewOptionKeys.countDownSeconds:@(0),
        STFloatViewOptionKeys.isWindowLevel:@(NO),
        STFloatViewOptionKeys.enablePanGesture:@(NO),
        STFloatViewOptionKeys.enableClose:@(NO),
        STFloatViewOptionKeys.closeBtnImageName:@"",
        STFloatViewOptionKeys.closeBtnBaseOnLeft:@(NO),
    }];
}

- (void)presentFloatImage:(UIImage *)floatImage
            withOptions:(NSDictionary *)options
                  clickBlock:(STFloatClickBlock)completion {
    [self stFloatView_registerDefaultsAndOptions:options];  //Default Setting
    
    UIView *target = [self stFloatView_parentTarget];
    UIButton *btn = [target viewWithTag:kFloatBtnTag];
    if (btn) {
        [btn removeFromSuperview];
        btn = nil;
    }

    //Defalut Image Size
    CGFloat imgWidth =[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalImageWidth] floatValue]?:floatImage.size.width;
    CGFloat imgHeight = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalImageHeight] floatValue]?:floatImage.size.height;
    CGFloat origalX = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalFrameX]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalFrameX] floatValue]:target.frame.size.width;
    CGFloat origalY = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalFrameY]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.origalFrameY] floatValue]:(target.frame.size.height-imgHeight)/2;
    
    UIButton *activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(origalX, origalY, imgWidth, imgHeight)];
    activityBtn.backgroundColor = [UIColor redColor];
    [activityBtn setImage:floatImage forState:UIControlStateNormal];
    [activityBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        UILabel *countDownLabel = [activityBtn viewWithTag:kcountDownLabelTag];
        if (countDownLabel && !countDownLabel.hidden) {
            return;
        }
        if (completion) {
            completion();
        }
    }];
    activityBtn.tag = kFloatBtnTag;
    [target addSubview:activityBtn];
    
    if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.enableCountDown] boolValue] && [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.countDownSeconds] intValue] > 0 ) {
        CGFloat finalImgWidth = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalImageWidth] floatValue]?:floatImage.size.width;
        CGFloat finalImgHeight = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalImageHeight] floatValue]?:floatImage.size.height;
        UILabel *countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, finalImgHeight/2, finalImgWidth-10, finalImgHeight/2-5)];
        countDownLabel.backgroundColor = CountDownLabelBgColor;
        countDownLabel.textColor = CountDownLabelTextColor;
        countDownLabel.font = CountDownLabelFont;
        countDownLabel.layer.cornerRadius = CountDownLabelCornerRadius;
        countDownLabel.layer.masksToBounds = YES;
        countDownLabel.textAlignment = NSTextAlignmentCenter;
        countDownLabel.adjustsFontSizeToFitWidth = YES;
        countDownLabel.tag = kcountDownLabelTag;
        countDownLabel.hidden = YES;
        [activityBtn addSubview:countDownLabel];
        [self actvity_timeCountDown];
        [activityBtn setImage:floatImage forState:UIControlStateHighlighted];
    }

    if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.enablePanGesture] boolValue]) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesRec:)];
        [activityBtn addGestureRecognizer:panGesture];
    }
    [self performSelector:@selector(startAnimation:) withObject:floatImage afterDelay:0.01];
}

- (void)startAnimation:(UIImage *)floatImage {
    NSTimeInterval animationDuration = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.animationDuration] floatValue];
    UIButton *activityBtn = [[self stFloatView_parentTarget] viewWithTag:kFloatBtnTag];
    UIView *target = [self stFloatView_parentTarget];

    CGFloat stopImgWidth =[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopImageWidth] floatValue]?:floatImage.size.width;
    CGFloat stopImgHeight = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopImageHeight] floatValue]?:floatImage.size.height;
    CGFloat stopX = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopFrameX]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopFrameX] floatValue]:target.frame.size.width-stopImgWidth;
    CGFloat stopY = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopFrameY]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.stopFrameY] floatValue]:(target.frame.size.height-stopImgHeight)/2;
    
    CGFloat finalImgWidth = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalImageWidth] floatValue]?:floatImage.size.width;
    CGFloat finalImgHeight = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalImageHeight] floatValue]?:floatImage.size.height;
    CGFloat finalX = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalFrameX]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalFrameX] floatValue]:target.frame.size.width-finalImgWidth;
    CGFloat finalY = [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalFrameY]?[[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.finalFrameY] floatValue]:(target.frame.size.height-finalImgHeight)/2;
    
    [UIView animateWithDuration:animationDuration delay:0.f options:UIViewAnimationOptionLayoutSubviews animations:^{
        [activityBtn setFrame:CGRectMake(stopX, stopY, stopImgWidth,stopImgHeight)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration delay:animationDuration options:UIViewAnimationOptionLayoutSubviews animations:^{
                [activityBtn setFrame:CGRectMake(finalX, finalY, finalImgWidth,finalImgHeight)];
            } completion:^(BOOL finished) {
                if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.enableClose] boolValue] && [self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.closeBtnImageName]) {
                    [self addCloseBtn];
                }
                if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.enableCountDown] boolValue]) {
                    UILabel *countDownLabel = [activityBtn viewWithTag:kcountDownLabelTag];
                    countDownLabel.hidden = NO;
                }
            }];
    }];
}

- (void)actvity_timeCountDown {
    UIButton *activityBtn = [[self stFloatView_parentTarget] viewWithTag:kFloatBtnTag];
    UILabel *countDownLabel = [activityBtn viewWithTag:kcountDownLabelTag];
    
    __block dispatch_source_t _timer;
        if (_timer == nil) {
            __block NSInteger timeout = [[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.countDownSeconds] intValue];
            if (timeout!=0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0);
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout <= 0){
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            countDownLabel.hidden = YES;
                            [activityBtn setImage:nil forState:UIControlStateHighlighted];
                        });
                    } else {
                        NSInteger days = (int)(timeout/(3600*24));
                        NSInteger hours = (int)((timeout-days*24*3600)/3600);
                        NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                        NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                        NSString *strTime = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (days == 0 && hours == 0) {
                                countDownLabel.text = strTime;
                            } else {
                                countDownLabel.text = @"1小时后";
                            }
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
}

- (void)addCloseBtn {
    UIButton *activityBtn = [[self stFloatView_parentTarget] viewWithTag:kFloatBtnTag];
    UIImage *closeImage = [UIImage imageNamed:[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.closeBtnImageName]];
    CGFloat CloseBtnWidth = closeImage.size.width/2;
    CGFloat CloseBtnHeight = closeImage.size.height/2;

    UIButton *closeBtn;
    if ([[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.closeBtnBaseOnLeft] boolValue]) {
        closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(-CloseBtnWidth/2, -CloseBtnHeight/2, CloseBtnWidth, CloseBtnHeight)];
    } else {
        closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(activityBtn.frame.size.width-CloseBtnWidth/2, -CloseBtnHeight/2, CloseBtnWidth, CloseBtnHeight)];
    }
        
    closeBtn.userInteractionEnabled = YES;
    [closeBtn setImage:[UIImage imageNamed:[self stFloatView_optionOrDefaultForKey:STFloatViewOptionKeys.closeBtnImageName]] forState:UIControlStateNormal];
    [activityBtn addSubview:closeBtn];
    [closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [activityBtn removeFromSuperview];
    }];
}

#pragma mark - UIPanGesture

- (void)panGesRec:(UIPanGestureRecognizer *)recognizer {
    UIView *target = [self stFloatView_parentTarget];
    CGPoint point = [recognizer translationInView:target];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:target];
}

@end

