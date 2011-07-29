//
//  RootViewController.h
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "HCDrawingViewController.h"
#import "HCUserProfileViewController.h"

@interface HCActivityViewController : UITableViewController <NSFetchedResultsControllerDelegate, HCDrawingViewControllerDelegate, HCUserProfileViewControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)editUserProfile:(id)sender;
- (IBAction)createNewDrawing:(id)sender;

@end
