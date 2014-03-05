//
//  MICoreDataTableViewController.m
//  Miami
//
//  Created by Igor Bogatchuk on 2/26/14.
//  Copyright (c) 2014 Igor Bogatchuk. All rights reserved.
//

#import "MICoreDataTableViewController.h"
#import "MITweet.h"
#import "MIMedia.h"
#import "MIModel.h"
#import "MIAppDelegate.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "MIRefreshingTableView.h"
#import "MITweetTableViewCell.h"
#import "MIRetweetTableViewCell.h"
#import "MITableViewCell.h"

#define REFRESH_THRESHOLD 60

NSString* const kTweetCellIdentifier = @"kMITweetCellIdentifier";
NSString* const kRetweetCellIdentifier = @"kMIRetweetCellIdentifier";

@interface MICoreDataTableViewController() <UIScrollViewDelegate>
{
    NSFetchedResultsController* _fetchedResultsController;
}

@property (nonatomic) BOOL beganUpdates;

@end

@implementation MICoreDataTableViewController

#pragma mark - Properties

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize beganUpdates = _beganUpdates;

#pragma mark - 

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"MITweet"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return _fetchedResultsController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController)
    {
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            [self performFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	MITweet* tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
	MITweetTableViewCell* cell = nil;
	if ([tweet.isRetweeted boolValue] == YES)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:kRetweetCellIdentifier];
	}
	else
	{
        cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellIdentifier];
	}
    [cell setUpWithTweet:tweet];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MITweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [tweet.isRetweeted boolValue] == YES ? [MIRetweetTableViewCell cellHeightForTwit:tweet] : [MITweetTableViewCell cellHeightForTwit:tweet];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];

}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{		
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)viewDidLoad
{
	[self.tableView registerNib:[UINib nibWithNibName:@"MIRetweetTableViewCell" bundle:nil] forCellReuseIdentifier:kRetweetCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"MITweetTableViewCell" bundle:nil] forCellReuseIdentifier:kTweetCellIdentifier];

    self.managedObjectContext = ((MIAppDelegate*)[UIApplication sharedApplication].delegate).dataModel.managedObjectContext;
}

#pragma mark -

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	CGFloat contentOffset = scrollView.contentOffset.y;
	if (contentOffset < - REFRESH_THRESHOLD)
	{
		[(MIRefreshingTableView *)self.tableView startRefreshing:^
		{
			[self refreshTableView];
		}
		withCompletionHanler:^
		{
		}];
	}
}

- (void)refreshTableView
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.fetchLimit = 1;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
	MIModel *model = ((MIAppDelegate*)[UIApplication sharedApplication].delegate).dataModel;
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MITweet" inManagedObjectContext:model.managedObjectContext];
	request.entity = entity;
	
	MITweet* lastTweet = (MITweet*)[[model.managedObjectContext executeFetchRequest:request error:NULL]lastObject];
	NSLog(@"lastTweetid:%@",lastTweet.unique);
	
	[model loadTweetsSinceId:lastTweet.unique];
}

@end

