//
//  CD_DataItem.m
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

#import "CD_DataItem.h"

@interface CD_DataItem ()
@property (nonatomic, strong, readwrite) NSString *itemName;
@property (nonatomic, strong, readwrite) NSURL *itemLocation;
@end

@implementation CD_DataItem

- (id)initWithTitle:(NSString *)title andURL:(NSURL *)url {
  self = [super init];
  if (self) {
    _itemName = title;
    _itemLocation = url;
  }
  return self;
}

@end
