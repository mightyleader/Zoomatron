//
//  CD_DatasourceObject.h
//  Zoomatron
//
//  Created by Rob Stearn on 18/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import Foundation;

@interface CD_DatasourceObject : NSObject <UITableViewDataSource>
- (BOOL)persistData;
- (id)objectAtIndex:(NSInteger)index;
- (NSInteger)count;
@end
