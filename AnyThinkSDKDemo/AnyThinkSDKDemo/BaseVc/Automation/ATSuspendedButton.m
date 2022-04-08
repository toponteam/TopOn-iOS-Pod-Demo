//
//  ATSuspendedButton.m
//  TestHashMap
//
//  Created by mac on 2022/1/20.
//

#import "ATSuspendedButton.h"
#import "ATAutomationTestViewController.h"

@interface ATSuspendedButton()

@property (nonatomic, strong) ATAutomationTestViewController *atomicVc;

@end

@implementation ATSuspendedButton

#pragma mark - publick
- (void)recordWithPlacementId:(NSString *)placementId protocol:(NSString *)protocolMethod;
{
    [self.atomicVc recordWithPlacementId:placementId protocol:protocolMethod];
}

#pragma mark - private
- (instancetype)initWithProtocolList:(NSArray *)protocolList
{
    if (self = [super init]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
         pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(clickSuspendedButton) forControlEvents:UIControlEventTouchUpInside];
        [self.atomicVc getProtocolMethodListFromProtocolList:protocolList];
    }
    return self;
}

- (void)clickSuspendedButton
{
    [[self superViewController] presentViewController:self.atomicVc animated:YES completion:nil];
}

- (UIViewController *)superViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//改变位置
-(void)locationChange:(UIPanGestureRecognizer*)p
{
    //[[UIApplication sharedApplication] keyWindow]
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if (p.state == UIGestureRecognizerStateEnded) {
        if (panPoint.x <= UIScreen.mainScreen.bounds.size.width / 2) {
            if (panPoint.y < kStatusBarHeight) {
                panPoint.y = kStatusBarHeight + self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if (panPoint.y > kStatusBarHeight && panPoint.y < panPoint.x) {
                panPoint.y = kStatusBarHeight + self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if (panPoint.y > UIScreen.mainScreen.bounds.size.height - self.frame.size.height) {
                panPoint.y = UIScreen.mainScreen.bounds.size.height - self.frame.size.height;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if ((UIScreen.mainScreen.bounds.size.height - panPoint.y) < panPoint.x) {
                panPoint.y = UIScreen.mainScreen.bounds.size.height - self.frame.size.height;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(self.frame.size.width / 2, panPoint.y);
                }];
            }
        } else {
            if (panPoint.y < kStatusBarHeight) {
                panPoint.y = kStatusBarHeight + self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if (panPoint.y > kStatusBarHeight && panPoint.y < (UIScreen.mainScreen.bounds.size.width - panPoint.x)) {
                panPoint.y = kStatusBarHeight + self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if (panPoint.y > UIScreen.mainScreen.bounds.size.height - self.frame.size.height) {
                panPoint.y = UIScreen.mainScreen.bounds.size.height - kButtonSafeHeight - self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else if ((UIScreen.mainScreen.bounds.size.height - panPoint.y) < (UIScreen.mainScreen.bounds.size.width - panPoint.x)) {
                panPoint.y = UIScreen.mainScreen.bounds.size.height - kButtonSafeHeight - self.frame.size.height / 2;
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(panPoint.x, panPoint.y);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(UIScreen.mainScreen.bounds.size.width - self.frame.size.width / 2, panPoint.y);
                }];
            }
        }
    }
}

#pragma mark - lazy
- (ATAutomationTestViewController *)atomicVc
{
    if (!_atomicVc) {
        _atomicVc = [[ATAutomationTestViewController alloc] init];

//        _atomicVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _atomicVc;
}

@end
