//
//  UIViewController+STFloatView.h
//
//  Created by admin on 2021/1/28.
//

@interface NSObject (STFloatViewRegister)
- (void)stFloatView_registerOptions:(NSDictionary *)options
                  defaults:(NSDictionary *)defaults;
- (id)stFloatView_optionOrDefaultForKey:(NSString *)optionKey;
@end

extern const struct STFloatViewOptionKeys {
    __unsafe_unretained NSString *animationDuration;
    __unsafe_unretained NSString *enableCountDown;
    __unsafe_unretained NSString *countDownSeconds;
    
    __unsafe_unretained NSString *origalImageWidth;
    __unsafe_unretained NSString *origalImageHeight;
    __unsafe_unretained NSString *stopImageWidth;
    __unsafe_unretained NSString *stopImageHeight;
    __unsafe_unretained NSString *finalImageWidth;
    __unsafe_unretained NSString *finalImageHeight;
    
    __unsafe_unretained NSString *isWindowLevel;
    __unsafe_unretained NSString *enablePanGesture;
    __unsafe_unretained NSString *enableClose;
    __unsafe_unretained NSString *closeBtnImageName;
    __unsafe_unretained NSString *closeBtnBaseOnLeft;
    
    __unsafe_unretained NSString *origalFrameX;
    __unsafe_unretained NSString *origalFrameY;
    __unsafe_unretained NSString *stopFrameX;
    __unsafe_unretained NSString *stopFrameY;
    __unsafe_unretained NSString *finalFrameX;
    __unsafe_unretained NSString *finalFrameY;
} STFloatViewOptionKeys;

typedef void (^STFloatClickBlock)(void);

@interface UIViewController (STFloatView)

- (void)presentFloatImage:(UIImage *)floatImage
            withOptions:(NSDictionary *)options
                  clickBlock:(STFloatClickBlock)completion;

@end

