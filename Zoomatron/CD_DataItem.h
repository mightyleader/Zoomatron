//
//  CD_DataItem.h
//  Zoomatron
//
//  Created by Rob Stearn on 22/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import Foundation;

@interface CD_DataItem : NSObject
@property (nonatomic, strong, readonly) NSString *itemName;
@property (nonatomic, strong, readonly) NSURL *itemLocation;

- (id)initWithTitle:(NSString *)title andURL:(NSURL *)url;
@end
