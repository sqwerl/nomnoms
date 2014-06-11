//
//  FARestaurantInfoPageViewController.m
//  NomNom
//
//  Created by Larry Cao on 5/26/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FARestaurantInfoPageViewController.h"

@interface FARestaurantInfoPageViewController ()

@end

@implementation FARestaurantInfoPageViewController

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
    
    NSArray *viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"restaurantLocationViewController"]];
    

    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    
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

#pragma mark - UIPageViewDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
//    if (viewController isKindOfClass:(__unsafe_unretained Class))
    return [self.storyboard instantiateViewControllerWithIdentifier:@"retaurantLocationViewController"];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    return [self.storyboard instantiateViewControllerWithIdentifier:@"retaurantLocationViewController"];
}

@end
