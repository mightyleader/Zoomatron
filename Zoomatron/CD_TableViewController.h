//
//  CD_TableViewController.h
//  Zoomatron
//
//  Created by Rob Stearn on 18/12/2013.
//  Copyright (c) 2013 Cocoadelica. All rights reserved.
//

@import UIKit;
#import "CD_DatasourceObject.h"

@interface CD_TableViewController : UITableViewController
@property (nonatomic, strong) CD_DatasourceObject *dataObject;
@end
