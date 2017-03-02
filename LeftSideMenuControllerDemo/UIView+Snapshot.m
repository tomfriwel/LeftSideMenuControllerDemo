//
//  UIView+Snapshot.m
//  LeftSideMenuControllerDemo
//
//  Created by tomfriwel on 02/03/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIView *)takeASnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView  = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = image;
    return imageView;
}

@end
