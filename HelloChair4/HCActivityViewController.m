//
//  RootViewController.m
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HCActivityViewController.h"
#import "CDDrawing.h"
#import "CDDrawing+RemixAdditions.h"
#import "CKCouchDB.h"

#define kCellImageViewTag 1000

@interface HCActivityViewController ()

- (void)updateUserNameButton;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell withObject:(CDDrawing *)anObject;

@end

@implementation HCActivityViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewDrawing:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self updateUserNameButton];
    
    [[CKCouchDB sharedCouchDB] getObjects];
    [[CKCouchDB sharedCouchDB] awaitChanges];
}

- (void)updateUserNameButton
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:HCUserNameKey];
    UIBarButtonItem *profileButton = [[[UIBarButtonItem alloc] initWithTitle:userName style:UIBarButtonItemStylePlain target:self action:@selector(editUserProfile:)] autorelease];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    if (!userName) 
    {
        [self editUserProfile:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)] autorelease];
        imageView.tag = kCellImageViewTag;
        [cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDDrawing *drawing = (CDDrawing *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    HCDrawingViewController *drawingViewController = [HCDrawingViewController drawingViewController];
    drawingViewController.delegate = self;
    drawingViewController.managedObjectContext = self.managedObjectContext;
    drawingViewController.drawing = [drawing drawingForRemixing];
    
    [self presentModalViewController:[[[UINavigationController alloc] initWithRootViewController:
                                       drawingViewController] autorelease] 
                            animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CDDrawing *drawing = (CDDrawing *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:drawing];
}

- (void)configureCell:(UITableViewCell *)cell withObject:(CDDrawing *)anObject
{
    CDDrawing *drawing = anObject;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %i", drawing.name, [(NSArray *)drawing.treePath count]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", drawing.userName];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:kCellImageViewTag];
    imageView.image = drawing.previewImage;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [CDDrawing entityInManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return __fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
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
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Actions

- (IBAction)editUserProfile:(id)sender
{
    HCUserProfileViewController *userProfileViewController = [[[HCUserProfileViewController alloc] initWithNibName:@"HCUserProfileViewController" bundle:nil] autorelease];
    userProfileViewController.delegate = self;
    
    [self presentModalViewController:[[[UINavigationController alloc] initWithRootViewController:
                                       userProfileViewController] autorelease] 
                            animated:YES];
}

- (IBAction)createNewDrawing:(id)sender
{
    HCDrawingViewController *drawingViewController = [HCDrawingViewController drawingViewController];
    drawingViewController.delegate = self;
    drawingViewController.managedObjectContext = self.managedObjectContext;
    
    [self presentModalViewController:[[[UINavigationController alloc] initWithRootViewController:
                                       drawingViewController] autorelease] 
                            animated:YES];
}

#pragma mark - HCDrawingViewControllerDelegate

- (void)drawingViewControllerDidFinish:(HCDrawingViewController *)aDrawingViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - HCUserProfileViewControllerDelegate

- (void)userProfileViewControllerDidFinish:(HCUserProfileViewController *)aUserProfileViewController
{
    [self updateUserNameButton];
    [self dismissModalViewControllerAnimated:YES];
}

@end
