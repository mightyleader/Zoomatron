//
//  CD_TableViewController.m
//  Zoomatron
//
//  Created by Rob Stearn on 18/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_TableViewController.h"
#import "CD_ModalImageViewController.h"

@interface CD_TableViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CD_TableViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setContentInset:UIEdgeInsetsMake(32, 0, 44, 0)];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  self.dataObject = [[CD_DatasourceObject alloc] init];
  [self.tableView setDataSource:self.dataObject];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Tableview Delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
  UIImageView *cellImageView = selectedCell.imageView;
  UIImage *selectedImage = [cellImageView image];
  CGRect sourceRect = CGRectMake(CGRectGetMinX(selectedCell.frame), CGRectGetMinY(selectedCell.frame), CGRectGetWidth(cellImageView.frame), CGRectGetHeight(cellImageView.frame));
  CD_ModalImageViewController *modalImage = [[CD_ModalImageViewController alloc] initWithImage:selectedImage andStartingFrame:sourceRect];
  [modalImage setModalPresentationStyle:UIModalPresentationCustom];
  [modalImage setTransitioningDelegate:modalImage];
  [modalImage setImageTitle:selectedCell.textLabel.text];
  [self presentViewController:modalImage animated:YES completion:nil];
}


@end
