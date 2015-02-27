//
//  CFListViewController.m
//  Charity Finder
//
//  Created by Michael Thomas on 2/5/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import "CFListViewController.h"
#import <DATASource.h>
#import <DATAStack.h>
#import "Charity.h"
#import "CFClient.h"

@interface CFListViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DATASource *dataSource;
@property (nonatomic, strong) DATAStack *dataStack;

@end

@implementation CFListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Get DATAStack
    _dataStack = [[CFClient sharedInstance] dataStack];
    
    // Setup table
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CFCharityTableCell"];
    self.tableView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [[[_dataSource fetchedResultsController] fetchRequest] setFetchLimit:0];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
        
        [[[_dataSource fetchedResultsController] fetchRequest] setPredicate:predicate];
        [[[_dataSource fetchedResultsController] fetchRequest] setFetchLimit:50];
    }
    
    NSError *error;
    if (![[_dataSource fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Lazy initialization

- (DATASource *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    
    // Charity fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Charity"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    // Setup data source
    _dataSource = [[DATASource alloc] initWithTableView:self.tableView fetchRequest:fetchRequest cellIdentifier:@"CFCharityTableCell" mainContext:self.dataStack.mainContext];
    
    // Data source cell block
    _dataSource.configureCellBlock = ^(UITableViewCell *cell, Charity *charity, NSIndexPath *indexPath) {
        cell.textLabel.text = charity.name;
    };
    
    return _dataSource;
}

#pragma mark - Actions

- (void)startCharitySync {
    [[CFClient sharedInstance] downloadCharityData:^(NSError *error) {
        if (error) {
            
        } else {
            
        }
    }];
}

@end
