//
//  FARestaurantViewController.m
//  Foodapp
//
//  Created by Larry Cao on 5/8/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FARestaurantViewController.h"


#import "FARestaurantInfoContentViewController.h"

#import "FARestaurantMenuContentViewController.h"

@interface FARestaurantViewController ()

@end

@implementation FARestaurantViewController

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
    
    self.address.text = [NSString stringWithFormat:@"Address: %@", self.addressString];
    
    self.phoneNumber.text = [NSString stringWithFormat:@"Phone number: %@", self.numberString];
    
    self.dataSource = self;
    
    NSArray *viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"restaurantMenuContentViewController"]];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // change color of back button
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // change color back to blue
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];

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


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[FARestaurantMenuContentViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantInfoContentViewController"];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[FARestaurantInfoContentViewController class]]) {
        return [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantMenuContentViewController"];
    }
    
    return nil;
}

@end
