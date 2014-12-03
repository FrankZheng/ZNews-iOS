//
//  MasterViewController.m
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsViewController.h"
#import "MOArticle.h"
#import "MOArticle+Dao.h"
#import "LibraryModel.h"
#import "ContentService.h"
//#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <AFNetworking.h>

#define kCellTitileViewTag  100
#define kCellDateViewTag    101
#define kCellImageViewTag   102
#define kCellSourceViewTag   103

@interface NewsListViewController ()
@property(nonatomic, strong) UIRefreshControl *bottomRefreshControl;

@end

@implementation NewsListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)refreshTop:(id)sender {
    [[LibraryModel instance] update:^{
        [self.refreshControl endRefreshing];
    } before:nil];
}

- (BOOL) connectedToNetwork
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (void) triggerRefreshAndUpdate {
    
    NSLog(@"connected to network: %d", [self connectedToNetwork]);
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self.refreshControl beginRefreshing];
    [self refreshTop:self.refreshControl];
}

#if 0

- (IBAction)refreshBottom:(id)sender {
    NSLog(@"load older News");
    //get the oldest news
    NSArray *sections = [self.fetchedResultsController sections];
    NSInteger section = sections.count - 1;
    id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    NSInteger row = [sectionInfo numberOfObjects] - 1;
    NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    MOArticle *article = (MOArticle *)[self.fetchedResultsController objectAtIndexPath:indexPath];
 
    [[LibraryModel instance] update:^{
        [self.bottomRefreshControl endRefreshing];
    } before:article.pubDate];

}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup top refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTop:)
                  forControlEvents:UIControlEventValueChanged];
    
#if 0
    //setup bottom refresh control
    self.bottomRefreshControl = [[UIRefreshControl alloc] init];
    [self.bottomRefreshControl addTarget:self
                            action:@selector(refreshBottom:)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = self.bottomRefreshControl;
#endif
    
    [self performSelector:@selector(triggerRefreshAndUpdate) withObject:nil afterDelay:0.001];
    //[self triggerRefreshAndUpdate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MOArticle *article = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:article];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MOArticle *article = (MOArticle*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSDateFormatter *df = nil;
    if(df == nil)
    {
        df = [[NSDateFormatter alloc] init];
        
    }
    
    if([[NSCalendar currentCalendar] isDateInToday:article.pubDate])
    {
        [df setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:kCellTitileViewTag];
    titleLabel.text = article.title;
    
    UILabel *dateLabel = (UILabel*)[cell viewWithTag:kCellDateViewTag];
    dateLabel.text = [df stringFromDate:article.pubDate];
    
    UIImageView *thumbView = (UIImageView *)[cell viewWithTag:kCellImageViewTag];
    [[ContentService instance] loadArticleThumbnail:article toImageView:thumbView];
    
    UILabel *sourceLabel = (UILabel*)[cell viewWithTag:kCellSourceViewTag];
    sourceLabel.text = article.publisher;
    
    //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    //NSLog(@"pubDate is %@", [df stringFromDate:article.pubDate]);
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
