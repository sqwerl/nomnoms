//
//  FAFoodProfileViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//


#define SAVE_PICTURE_URL @"hello"

#import "FAFoodProfileViewController.h"

@interface FAFoodProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *triedButton;


@end

@implementation FAFoodProfileViewController
- (IBAction)saveFood:(id)sender {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *foodURL = [NSURL URLWithString:SAVE_PICTURE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:foodURL];
    
    
    [request setHTTPMethod:@"Post"];
    
    
    
//    request setHTTPBody:<#(NSData *)#>
    
    
    [session dataTaskWithURL:foodURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        [self.saveButton setSelected:!self.saveButton.selected];
        
        if ([self.saveButton.titleLabel.text isEqualToString:@"save"
            ]) {
            self.saveButton.titleLabel.text = @"saved";
        } else {
            self.saveButton.titleLabel.text = @"save";
        }
        
    }];
    
    
}
- (IBAction)triedFood:(id)sender {
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageView.image = self.image;
//    self.view addSubview:
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.25 animations:^{
        

        self.navigationController.navigationBar.translucent = YES;

    }];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.25 animations:^{
        
        
        self.navigationController.navigationBar.translucent = NO;
        
    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
