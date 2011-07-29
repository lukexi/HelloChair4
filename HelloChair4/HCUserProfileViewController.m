//
//  HCUserProfileViewController.m
//  HelloChair4
//
//  Created by Luke Iannini on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HCUserProfileViewController.h"

@implementation HCUserProfileViewController
@synthesize userNameField;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
    
    [self.userNameField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setUserNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneAction:(id)sender 
{
    if (![self.userNameField.text length]) 
    {
        [[[[UIAlertView alloc] initWithTitle:@"I DON TINK SO" message:@"LISTEN PAPI YOU BETTER GIVE ME A NAME OR I CALL MY BROTHER AND THEN WE'LL SEE HOW YOU LIKE IT" delegate:nil cancelButtonTitle:@"OKAY LADY" otherButtonTitles: nil] autorelease] show];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text 
                                              forKey:HCUserNameKey];
    [self.delegate userProfileViewControllerDidFinish:self];
}

- (void)dealloc 
{
    [userNameField release];
    [super dealloc];
}

@end
