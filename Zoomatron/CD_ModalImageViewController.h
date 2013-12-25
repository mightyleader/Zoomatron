//
//  CD_ModalImageViewController.h
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import UIKit;
#import "CD_ModalFadeTransition.h"

@interface CD_ModalImageViewController : UIViewController <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *imageTitle;
@property (nonatomic) CGRect startingFrame;
@property (nonatomic, strong) CD_ModalFadeTransition *customTransition;
- (id)initWithImage:(UIImage *)selectedImage andStartingFrame:(CGRect)startingFrame;
@end
