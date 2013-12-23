//
//  CD_ModalImageViewController.m
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_ModalImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CD_ModalImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
- (CGRect)frameForImageSize:(CGSize)imageSize;
- (void)addTitleToImage;
@end

@implementation CD_ModalImageViewController

- (id)initWithImage:(UIImage *)selectedImage andStartingFrame:(CGRect)startingFrame {
  self = [super init];
  if (self) {
    _selectedImage = selectedImage;
    _startingFrame = startingFrame;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  CGSize imageSize = self.selectedImage.size;
  CGRect imageRect = [self frameForImageSize:imageSize];
	_imageView = [[UIImageView alloc] initWithFrame:imageRect];
  [_imageView setContentMode:UIViewContentModeScaleAspectFit];
  [self addTitleToImage];
  [self.imageView setImage:self.selectedImage];
  [self.imageView setUserInteractionEnabled:YES];
  [self.imageView.layer setCornerRadius:7.0];
  [self.imageView.layer setMasksToBounds:YES];
  self.view = self.imageView;
  
  UITapGestureRecognizer *singleTapAnywhere = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMe)];
  [singleTapAnywhere setNumberOfTapsRequired:1];
  [singleTapAnywhere setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:singleTapAnywhere];
}

- (CGRect)frameForImageSize:(CGSize)imageSize {
  CGFloat xValue = 0.0, yValue = 0.0 , widthValue, heightValue;
  CGFloat imageRatio = imageSize.height / imageSize.width;
#pragma message ("Using magic numbers for frames breaks support across devices")
  widthValue = 320;
  heightValue = widthValue * imageRatio;
  return CGRectMake(xValue, yValue, widthValue, heightValue);
}

- (void)addTitleToImage {
  if (self.imageTitle) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.frame) - 30, CGRectGetWidth(self.imageView.frame), 30)];
    [titleLabel setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:12.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:self.imageTitle];
    [self.imageView addSubview:titleLabel];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dismissMe {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Animated Transition handler

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  if (!self.customTransition) {
    self.customTransition = [[CD_ModalFadeTransition alloc] init];
    [self.customTransition setOriginalRect:self.startingFrame];
    [self.customTransition setPresenting:YES];
  }
  return self.customTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  [self.customTransition setPresenting:NO];
  return self.customTransition;
}

@end