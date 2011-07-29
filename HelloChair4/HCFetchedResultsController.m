//
//  HCFetchedResultsController.m
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HCFetchedResultsController.h"

@interface HCFetchedResultsController ()

@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readwrite) NSFetchRequest *fetchRequest;

@property (nonatomic, retain) NSMutableArray *mutableFetchedObjects;

@end

@implementation HCFetchedResultsController
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize fetchRequest;
@synthesize mutableFetchedObjects;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSManagedObjectContextObjectsDidChangeNotification 
                                                  object:managedObjectContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSManagedObjectContextDidSaveNotification 
                                                  object:managedObjectContext];
    [mutableFetchedObjects release];
    [managedObjectContext release];
    [fetchRequest release];
    [super dealloc];
}

#pragma mark - NSFetchedResultsController

+ (id)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath delegate:(id <NSFetchedResultsControllerDelegate>)delegate
{
    HCFetchedResultsController *fetchedResultsController = [[[self alloc] init] autorelease];
    fetchedResultsController.fetchRequest = fetchRequest;
    fetchedResultsController.managedObjectContext = context;
    fetchedResultsController.delegate = delegate;
    return fetchedResultsController;
}

- (BOOL)performFetch:(NSError **)error
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(contextDidChange:) 
                                                 name:NSManagedObjectContextObjectsDidChangeNotification 
                                               object:self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(contextDidSave:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:self.managedObjectContext];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:self.fetchRequest 
                                                                error:error];
    
    self.mutableFetchedObjects = [[results mutableCopy] autorelease];
    
    return results != nil;
}

- (NSArray *)fetchedObjects
{
    return self.mutableFetchedObjects;
}

- (void)contextDidChange:(NSNotification *)notification
{
//    NSDictionary *userInfo = [notification userInfo];
//    
//    NSSet *updatedObjects = [userInfo objectForKey:NSUpdatedObjectsKey];
//    NSSet *deletedObjects = [userInfo objectForKey:NSDeletedObjectsKey];
//    NSSet *insertedObjects = [userInfo objectForKey:NSInsertedObjectsKey];
    
    
}

- (void)contextDidSave:(NSNotification *)notification
{
    
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

@end
