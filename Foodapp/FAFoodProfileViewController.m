//
//  FAFoodProfileViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//


#define SAVE_PICTURE_URL @"hello"

#import "FAFoodProfileViewController.h"
#import "FARestaurantViewController.h"

@implementation FoodDescriptionView

@end

@implementation RestaurantDescriptionView

@end

@interface FAFoodProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *triedButton;

@property (weak, nonatomic) IBOutlet FoodDescriptionView *foodDescriptionView;
@property (weak, nonatomic) IBOutlet RestaurantDescriptionView *restaurantDescriptionView;

@end

@implementation FAFoodProfileViewController


- (void)showRestaurant {
    
}

- (IBAction)saveFood:(id)sender {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *foodURL = [NSURL URLWithString:SAVE_PICTURE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:foodURL];
    
    
    [request setHTTPMethod:@"Post"];
    
    
    
//    request setHTTPBody:
    
    
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
    
    
    // hide status bar
    
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
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    

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
    
    self.foodDescriptionView.dishname.text = self.data[@"name"];
    
    self.foodDescriptionView.details.text = self.data[@"restaurant"][@"kind"];
    
    self.foodDescriptionView.description.text = self.data[@"description"];
    
    self.restaurantDescriptionView.restaurantName.text = self.data[@"restaurant"][@"name"];
    
    self.restaurantDescriptionView.restaurantDetails.text = self.data[@"restaurant"][@"address"];
    
    
//    self.navigationItem.rightBarButtonItem
    
    // Do any additional setup after loading the view.
    
    // change color of back button
    self.navigationController.navigationBar.topItem.title = @"";

    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRestaurant"]) {
        FARestaurantViewController *restaurantViewController = [segue destinationViewController];
    
        restaurantViewController.title = self.data[@"restaurant"][@"name"];

        
        restaurantViewController.addressString = self.data[@"restaurant"][@"address"];
        
        restaurantViewController.numberString = self.data[@"restaurant"][@"number"];
    }
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
