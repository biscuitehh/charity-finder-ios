//
//  CFListViewController.h
//  Charity Finder
//
//  Created by Michael Thomas on 2/5/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFListViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchResults;

- (IBAction)searchButtonAction:(id)sender;

@end

