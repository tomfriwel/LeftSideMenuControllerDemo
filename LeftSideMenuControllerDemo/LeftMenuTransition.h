//
//  LeftMenuTransition.h
//  LeftSideMenuControllerDemo
//
//  Created by tomfriwel on 02/03/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPercentDriven;
@property (nonatomic, assign) BOOL isPresent;   // is present or dismiss

-(instancetype)initWithIsPresent:(BOOL)isPresent;

@end
