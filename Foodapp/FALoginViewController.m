//
//  FALoginViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/1/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FALoginViewController.h"
#import "FAMainViewController.h"

@interface FALoginViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;

@end

@implementation FALoginViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.username becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
//    if (self.username.text )
    if (![self.username.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (![self.password.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURL *loginURL = [NSURL URLWithString:@"http://foodapp-dev.herokuapp.com/api/v1/log_in"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

        [request setHTTPMethod:@"POST"];
        
        NSString *lowercaseUsername = [self.username.text lowercaseString];
        
        NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@", lowercaseUsername, self.password.text];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

        
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSError *e;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            
            NSLog(@"%@", json);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([json[@"response_code"] isEqualToString:@"failure"]) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid username/password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else if ([json[@"response_code"] isEqualToString:@"success"]) {
                    FAMainViewController *mainViewController = [[self.navigationController viewControllers] objectAtIndex:0];
                    [mainViewController loadData];
                    [self.navigationController popToViewController:mainViewController animated:NO];
                }
            });

        }] resume];
    }
//        UIAlertView *enterPassword
    NSLog(@"login");
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    } else {
        [self loginPressed:nil];
    }
    
    return YES;
}

@end
