//
//  CDDrawing+RemixAdditions.m
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDDrawing+RemixAdditions.h"
#import "CoreDataJSONKit.h"
#import "NSString+Additions.h"

@implementation CDDrawing (CDDrawing_RemixAdditions)

- (CDDrawing *)drawingForRemixing
{
    CDDrawing *remixDrawing = [CDDrawing cj_insertInManagedObjectContext:self.managedObjectContext 
                                                   fromObjectDescription:[self cj_dictionaryRepresentation]];
    
    remixDrawing.userName = [[NSUserDefaults standardUserDefaults] objectForKey:HCUserNameKey];
    remixDrawing.timeStamp = [NSDate date];
    remixDrawing.couchID = [NSString cj_UUID];
    remixDrawing.couchRev = nil;
    
    NSMutableArray *branchTreePath = [[remixDrawing.treePath mutableCopy] autorelease];
    [branchTreePath addObject:remixDrawing.couchID];
    remixDrawing.treePath = branchTreePath;
    
    return remixDrawing;
}

@end
