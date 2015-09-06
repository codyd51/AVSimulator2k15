#import <objc/runtime.h>

#define kTweakName @"AVSimulator2k15"
#ifdef DEBUG
    #define NSLog(FORMAT, ...) NSLog(@"[%@: %s - %i] %@", kTweakName, __FILE__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
    #define NSLog(FORMAT, ...) do {} while(0)
#endif

#define kExpiredImagePath @"/Library/Application Support/AVSimulator2k15/expired.png"

//making the alert dismissable by tapping made me sad
//until then this tweak was one constructor and one function
//i didn't want to add more bloat by adding a handler class for the dismiss button
//so instead we have a class for a block-based UIButton
//because I reasoned that having a class was better than having a class ¯\_(ツ)_/¯
typedef void (^ActionBlock)();
@interface UIBlockButton : UIButton {
    ActionBlock _actionBlock;
}
-(void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;
@end
@implementation UIBlockButton
-(void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action {
    _actionBlock = [action copy];
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}
-(void)callActionBlock:(id)sender{
    _actionBlock();
}

-(void)dealloc{
    Block_release(_actionBlock);
}
@end

//forward declarations
@interface FBDisplayManager : NSObject
+(id)mainDisplay;
@end
@interface FBSceneManager : NSObject
+(id)sharedInstance;
-(UIView*)_rootWindowForDisplay:(FBDisplayManager*)display;
@end


void xDSmokeDayEveryMemes() {
    //after 20 minutes we show the alert at a random interval between 20 minutes and 1 hour
    //20 minutes in seconds
    NSInteger lowerBound = 1200;
    //1 hour in seconds
    NSInteger upperBound = 3600;
    //random value between these two
    NSInteger randomDelay = lowerBound + arc4random() % (upperBound - lowerBound);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //create AV view
        UIBlockButton* expiredButton = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [expiredButton setBackgroundImage:[UIImage imageWithContentsOfFile:kExpiredImagePath] forState:UIControlStateNormal];
        //This tweak injects into SpringBoard only
        //If we were to simply add our view to [[UIApplication sharedApplication] keyWindow], our view would not show up when looking at an app
        //it would only show up on the homescreen
        //This uses FrontBoard's scene & screen manager to get the whole display's view, and adds to that
        //we must overengineer for maximum annoyance
        UIView* view = [[%c(FBSceneManager) sharedInstance] _rootWindowForDisplay:[%c(FBDisplayManager) mainDisplay]];
        CGRect screenFrame = view.frame;
        CGSize imageSize = CGSizeMake(screenFrame.size.width/1.5, screenFrame.size.height/3.75);
        expiredButton.frame = CGRectMake(screenFrame.size.width, screenFrame.size.height - imageSize.height, imageSize.width, imageSize.height);
        [view addSubview:expiredButton];

        [expiredButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(){
            [UIView animateWithDuration:1 animations:^{
                //slide out AV message
                expiredButton.frame = CGRectMake(expiredButton.frame.origin.x + expiredButton.frame.size.width, expiredButton.frame.origin.y, expiredButton.frame.size.width, expiredButton.frame.size.height);
            } completion:^(BOOL finished){
                [expiredButton removeFromSuperview];

                //repeat until the user inevitably uninstalls
                xDSmokeDayEveryMemes();
            }];
        }];

        [UIView animateWithDuration:1 animations:^{
            //slide in AV message
            expiredButton.frame = CGRectMake(expiredButton.frame.origin.x - expiredButton.frame.size.width, expiredButton.frame.origin.y, expiredButton.frame.size.width, expiredButton.frame.size.height);
        } completion:nil];
    });
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;

    xDSmokeDayEveryMemes();
}
%end
