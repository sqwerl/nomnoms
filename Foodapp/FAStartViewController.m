//
//  FAStartViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FAStartViewController.h"

@interface FAStartViewController () 
@property (weak, nonatomic) IBOutlet UIView *transparentView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation FAStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginButton.backgroundColor = [UIColor redColor];
    
    self.loginButton.titleLabel.textColor = [UIColor whiteColor];
    
    self.loginButton.layer.cornerRadius = 15;
    
    
    self.signupButton.backgroundColor = [UIColor whiteColor];
    self.signupButton.titleLabel.textColor = [UIColor redColor];
    
    self.signupButton.layer.cornerRadius = 15;
    
    self.transparentView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    
//    [FBProfilePictureView class];
//    
//    [FBLoginView class];
//    
//    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",@"email",@"user_friends"]];
//    
//    loginView.delegate = self;
//
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width)), 5);
    
//
//    loginView.center = self.view.center;
//    
//    //loginView.loginBehavior = FBSessionLoginBehaviorUseSystemAccountIfPresent;
//    
//    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginViewPressed)];
//    
//    [loginView addGestureRecognizer:singleFingerTap];
//    
//    [self.view addSubview:loginView];
    // Do any additional setup after loading the view.
}

- (void)loginViewPressed {
    NSLog(@"hello");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"loginviewfetch");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShow");
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
