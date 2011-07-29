//
//  HCUserProfileViewController.h
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class HCUserProfileViewController;
@protocol HCUserProfileViewControllerDelegate <NSObject>

- (void)userProfileViewControllerDidFinish:(HCUserProfileViewController *)aUserProfileViewController;

@end

@interface HCUserProfileViewController : UIViewController {
    UITextField *userNameField;
}


@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (assign, nonatomic) id <HCUserProfileViewControllerDelegate> delegate;
- (IBAction)doneAction:(id)sender;

@end
