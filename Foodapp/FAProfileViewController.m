//
//  FAProfileViewController.m
//  Foodapp
//
//  Created by Larry Cao on 5/7/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FAProfileViewController.h"

@interface FAProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UIButton *settings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *formatControl;

@end

@implementation FAProfileViewController

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
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = @"cover photo url";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    
    
    
    [session dataTaskWithURL:url];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
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
