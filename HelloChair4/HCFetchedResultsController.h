//
//  HCFetchedResultsController.h
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HCFetchedResultsController : NSObject

+ (id)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath delegate:(id <NSFetchedResultsControllerDelegate>)delegate;

@property (nonatomic, assign) id <NSFetchedResultsControllerDelegate> delegate;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic, readonly) NSArray *fetchedObjects;

@end
