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
#import "CFSearchResultsViewController.h"
#import <UIScrollView+InfiniteScroll.h>

@interface CFListViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DATAStack *dataStack;
@property (nonatomic, strong) DATASource *dataSource;

// Search controller/results
@property (nonatomic, strong) UISearchController *searchController;

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
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CFSearchResultsViewController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;


    // Infinite scroll indicator style
//    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
//    
//    // Setup infinite scroll
//    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
//        // Fetch more charities
//        [[CFClient sharedInstance] downloadCharityDataAtStart:[tableView numberOfRowsInSection:0] count:200 completion:^(NSError *error) {
//            if (error) {
//                
//            } else {
//                
//            }
//        }];
//        
//        // finish infinite scroll animation
//        [tableView finishInfiniteScroll];
//    }];
//    
//    // Initial sync
//    [[CFClient sharedInstance] downloadCharityDataAtStart:0 count:200 completion:^(NSError *error) {
//        if (error) {
//            
//        } else {
//            
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search bar

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = nil;
    
//    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
//    if (selectedScopeButtonIndex > 0) {
//        scope = [[Product deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
//    }
//    
//    [self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        CFSearchResultsViewController *vc = (CFSearchResultsViewController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }
    
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
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

@end
