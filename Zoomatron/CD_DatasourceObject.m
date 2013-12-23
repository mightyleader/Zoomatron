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
@property (nonatomic, strong, readwrite) NSMutableArray *referenceArray;
@property (nonatomic, strong) NSMutableArray *persistentArray;
@property (nonatomic, strong) NSData *tempImageData;
- (void)prepareData;
- (BOOL)restoreData;
- (NSString *)pathToArchive;
@end

@implementation CD_DatasourceObject

#pragma mark - Object lifecycle methods

- (id)init {
  self = [super init];
  if (self) {
    _referenceArray = [[NSMutableArray alloc] init];
    _tempImageData = UIImagePNGRepresentation([UIImage imageNamed:@"tempImage"]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistData) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistData) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistData) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self prepareData];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self persistData];
}

#pragma mark - Private data handling

- (void)prepareData {
  BOOL createPersistentArray = ![self restoreData];
  if (createPersistentArray) {
    _persistentArray = [[NSMutableArray alloc] init];
  }
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
    [self.referenceArray addObject:item];
    if (createPersistentArray) {
      [self.persistentArray addObject:self.tempImageData];
    }
  }
}

- (BOOL)restoreData {
  _persistentArray = [[NSArray arrayWithContentsOfFile:[self pathToArchive]] mutableCopy];
  return self.persistentArray;
}

- (NSString *)pathToArchive {
  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *fullPathToSave = [documentsPath stringByAppendingPathComponent:@"macImages.xml"];
  return fullPathToSave;
}

#pragma mark - Public accessors

- (BOOL)persistData {
  BOOL result;
  NSString *filePath = [self pathToArchive];
  result = [self.persistentArray writeToFile:filePath atomically:YES];
  return YES;
}

- (id)objectAtIndex:(NSInteger)index {
  id object = nil;
  if (self.referenceArray && self.referenceArray.count >= index) {
    object = [self.referenceArray objectAtIndex:index];
  }
  return object;
}

- (NSInteger)count {
  NSInteger count = 0;
  if (self.referenceArray) {
    count = [self.referenceArray count];
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
  NSData *dataForImage = [self.persistentArray objectAtIndex:indexPath.row];
  UIImage *cellImage = [UIImage imageWithData:dataForImage];
  [cell.imageView setImage:cellImage];
  [cell.imageView.layer setCornerRadius:3.0];
  [cell.imageView.layer setMasksToBounds:YES];
  if (dataForImage == self.tempImageData) {
    [self downloadImageAtURL:[dataItem itemLocation] withCompletionHandler:^(NSData *imageData) {
      [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
      [self.persistentArray setObject:imageData atIndexedSubscript:indexPath.row];
      UIImage *imageToUse = [UIImage imageWithData:imageData];
      [cell.imageView setImage:imageToUse];
    }];
  }
  return cell;
}

#pragma mark - Private image retreival and processing
- (void)downloadImageAtURL:(NSURL *)url withCompletionHandler:(void(^)(NSData*))completion {
  NSOperationQueue *downloadQueue = [[NSOperationQueue alloc] init];
  [downloadQueue addOperationWithBlock:^{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      if (imageData) {
        completion(imageData);
      }
    }];
  }];
}

@end
