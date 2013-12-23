//
//  CD_ModalImageViewController.m
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_ModalImageViewController.h"
@import QuartzCore;
@import AVFoundation;

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

- (void)viewDidAppear:(BOOL)animated {
  [self addTitleToImage];
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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.frame) - 40, CGRectGetWidth(self.imageView.frame), 40)];
    [titleLabel setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:self.imageTitle];
    UIButton *speechButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [speechButton setImage:[UIImage imageNamed:@"speechIcon"] forState:UIControlStateNormal];
    [speechButton setFrame:CGRectMake(CGRectGetWidth(titleLabel.frame) - 40, 0, 40, 40)];
    [speechButton addTarget:self action:@selector(speakLabel:) forControlEvents:UIControlEventTouchUpInside];
    [speechButton setBackgroundColor:[UIColor blackColor]];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel addSubview:speechButton];
    [self.imageView addSubview:titleLabel];
    [titleLabel setAlpha:0.0];
    [UIView animateWithDuration:0.2 animations:^{
      [titleLabel setAlpha:1.0];
    }];
  }
}

- (void)speakLabel:(id)sender {
  AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
  AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.imageTitle];
  [utterance setRate:0.3];
  [speechSynthesizer speakUtterance:utterance];
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
