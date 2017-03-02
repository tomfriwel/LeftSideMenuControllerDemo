//
//  ViewController.m
//  LeftSideMenuControllerDemo
//
//  Created by tomfriwel on 02/03/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "ViewController.h"
#import "LeftMenuViewController.h"
#import "LeftMenuPresentation.h"
#import "LeftMenuTransition.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>

@property id percentDrivenTransition;
@property id dismissDrivenTransition;
@property (nonatomic, strong) LeftMenuViewController *leftMenu;
@property (nonatomic, strong) LeftMenuTransition *presentTransition;
@property (nonatomic, strong) LeftMenuTransition *dismissTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presentTransition = [[LeftMenuTransition alloc] initWithIsPresent:YES];
    self.dismissTransition = [[LeftMenuTransition alloc] initWithIsPresent:NO];
    
    [self createVC];
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:edgePanGesture];
}

-(void)createVC {
    self.leftMenu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    self.leftMenu.view.backgroundColor = [UIColor whiteColor];
    
    self.leftMenu.modalPresentationStyle = UIModalPresentationCustom;
    self.leftMenu.transitioningDelegate = self;
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanDismissGesture:)];

    [self.leftMenu.view addGestureRecognizer:swipeGesture];
}

- (IBAction)presentView:(id)sender {
    [self presentViewController:self.leftMenu animated:YES completion:nil];
}

-(void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = self.view.bounds.size.width;
    
    CGFloat progress = point.x / w ;
    
    NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    
    //    NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.presentTransition.isPercentDriven = YES;
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self presentViewController:self.leftMenu animated:YES completion:nil];
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
        self.presentTransition.isPercentDriven = NO;
    }
}

-(void)edgePanDismissGesture:(UIPanGestureRecognizer *)edgePan {
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = PRESENTATION_W;//self.view.bounds.size.width;
    CGPoint vel = [edgePan velocityInView:self.view];
    
    static BOOL perform = NO;
    if (vel.x < 0 && !perform) {
        perform = YES;
    }
    else {
    }
    
    CGFloat progress = -point.x / PRESENTATION_W;
    
    NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    
    //    NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan && perform) {
        self.dismissTransition.isPercentDriven = YES;
        self.dismissDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        //        [self.navigationController pushViewController:self.presentVC animated:YES];
        [self.leftMenu dismissViewControllerAnimated:YES completion:nil];
        //        self.navigationController?.popViewControllerAnimated(true)
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.dismissDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        perform = NO;
        if (progress > 0.3) {
            [self.dismissDrivenTransition finishInteractiveTransition];
        } else {
            [self.dismissDrivenTransition cancelInteractiveTransition];
        }
        self.dismissDrivenTransition = nil;
        self.dismissTransition.isPercentDriven = NO;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[LeftMenuPresentation alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissTransition;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.percentDrivenTransition;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.dismissDrivenTransition;
}

@end
