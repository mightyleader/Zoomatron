//
//  CD_DatasourceObject.h
//  Zoomatron
//
//  Created by Rob Stearn on 18/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import Foundation;

@protocol CD_DatasourceDelegate <NSObject>
@required
- (void)reloadTableView;
@end

@interface CD_DatasourceObject : NSObject <UITableViewDataSource>
@property (nonatomic, assign) id<CD_DatasourceDelegate> delegate;

- (void)reloadData:(id)sender;
- (BOOL)persistData;
- (id)objectAtIndex:(NSInteger)index;
- (NSInteger)count;
@end
