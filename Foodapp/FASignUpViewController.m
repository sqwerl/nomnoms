//
//  FASignUpViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/8/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FASignUpViewController.h"
#import "FAMainViewController.h"
#import "FoodApp.h"

@interface FASignUpViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *firstname;
@property (nonatomic, weak) IBOutlet UITextField *lastname;
@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;

@end

@implementation FASignUpViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.firstname becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUp:(id)sender {
    if (![self.firstname.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your first name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (![self.lastname.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your last name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (![self.username.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (![self.password.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURL *loginURL = [NSURL URLWithString:@"http://foodapp-dev.herokuapp.com/api/v1/sign_up"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        
        NSString *lowercaseUsername = [self.username.text lowercaseString];
        
        NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@&first_name=%@&last_name=%@", lowercaseUsername, self.password.text,self.firstname.text, self.lastname.text];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSError *e;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            
            NSLog(@"%@", json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([json[@"response_code"] isEqualToString:@"failure"]) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:json[@"error_msgs"][0] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else if ([json[@"response_code"] isEqualToString:@"success"]) {
                    [FoodApp loadUserConfigWithLogin:self.username.text userID:json[@"id"] authToken:json[@"token"]];
                    FAMainViewController *mainViewController = [[self.navigationController viewControllers] objectAtIndex:0];
                    [mainViewController loadData];
                    [self.navigationController popToViewController:mainViewController animated:NO];
                }
            });

        }] resume];
    }
}

#pragma mark - UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstname) {
        [self.lastname becomeFirstResponder];
    } else if (textField == self.lastname) {
        [self.username becomeFirstResponder];
    } else if (textField == self.username) {
        [self.password becomeFirstResponder];
    } else {
        [self signUp:nil];
    }
    
    return YES;
}

@end
