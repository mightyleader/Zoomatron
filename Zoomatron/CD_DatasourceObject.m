//
//  CD_DatasourceObject.m
//  Zoomatron
//
//  Created by Rob Stearn on 18/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_DatasourceObject.h"
#import "CD_DataItem.h"
#import <QuartzCore/QuartzCore.h>

@interface CD_DatasourceObject ()
@property (nonatomic, strong, readwrite) NSMutableArray *dataArray;
- (void)prepareData;
@end

@implementation CD_DatasourceObject

- (id)init {
  self = [super init];
  if (self) {
    _dataArray = [[NSMutableArray alloc] init];
    [self prepareData];
  }
  return self;
}

#pragma mark - Private data handling

- (void)prepareData {
  NSArray *names = @[@"Macintosh",
                     @"Macintosh Classic",
                     @"Macintosh Color Classic",
                     @"Power Macintosh G3",
                     @"20th Anniversary Macintosh",
                     @"Macintosh TV",
                     @"iMac G3"];
  NSArray *locations = @[@"http://oldcomputers.net/pics/macintosh.jpg",
                         @"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRiN6rhhe8V-xyLOWYLEOW7okVJlxToT0kpcX3yGq6Npms4ohDO",
                         @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSrkrFTCYHQ9MWPOR0BAKYJzZZSF7_L6tjnVtJQDXJcuMEURVjG",
                         @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ5-PaQkEpe-8VkTqPYb0lXAQE6hq-hO5322V7_eGZlAxqM16U1",
                         @"http://five12.wpengine.netdna-cdn.com/wp-content/uploads/misc/2012-12-03-TAM.jpeg",
                         @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThpP2p5LKyopoKJbSTjrb-oJeNJArTb4laWfTIzz75rXwhsCB0",
                         @"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcS9FlyBPTBg3CzoPRghGbpNfZItXeiLYdH4xy7NfxbpXOpxkYY"];
  for (NSString *name in names) {
    NSInteger index = [names indexOfObject:name];
    NSString *location = [locations objectAtIndex:index];
    CD_DataItem *item = [[CD_DataItem alloc] initWithTitle:name andURL:[NSURL URLWithString:location]];
    [self.dataArray addObject:item];
  }
}

#pragma mark - Public accessors

- (id)objectAtIndex:(NSInteger)index {
  id object = nil;
  if (self.dataArray && self.dataArray.count >= index) {
    object = [self.dataArray objectAtIndex:index];
  }
  return object;
}

- (NSInteger)count {
  NSInteger count = 0;
  if (self.dataArray) {
    count = [self.dataArray count];
  }
  return count;
}

#pragma mark - Tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  CD_DataItem *dataItem = [self objectAtIndex:indexPath.row];
  [cell.textLabel setText:[dataItem itemName]];
  [cell.textLabel setTextAlignment:NSTextAlignmentRight];
  [cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14.0]];
  [cell.imageView setImage:[UIImage imageNamed:@"tempImage"]];
  [self downloadImageAtURL:[dataItem itemLocation] withCompletionHandler:^(UIImage *image) {
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.imageView setImage:image];
    [cell.imageView.layer setCornerRadius:3.0];
    [cell.imageView.layer setMasksToBounds:YES];
  }];
  return cell;
}

#pragma mark - Private image retreival and processing
- (void)downloadImageAtURL:(NSURL *)url withCompletionHandler:(void(^)(UIImage*))completion {
  NSOperationQueue *downloadQueue = [[NSOperationQueue alloc] init];
  [downloadQueue addOperationWithBlock:^{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *returnedImage = [UIImage imageWithData:imageData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      if (returnedImage) {
        completion(returnedImage);
      }
    }];
  }];
}

@end
