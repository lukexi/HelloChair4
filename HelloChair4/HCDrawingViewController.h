//
//  HCDrawingViewController.h
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "CDDrawingViewController.h"

@class HCDrawingViewController;
@protocol HCDrawingViewControllerDelegate <NSObject>

- (void)drawingViewControllerDidFinish:(HCDrawingViewController *)aDrawingViewController;

@end


@interface HCDrawingViewController : CDDrawingViewController

@property (assign, nonatomic) id <HCDrawingViewControllerDelegate> delegate;

- (IBAction)submitAction:(id)sender;

@end
