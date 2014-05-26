//
//  FARestaurantViewController.h
//  Foodapp
//
//  Created by Larry Cao on 5/8/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FARestaurantViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@property (nonatomic, strong) NSString *addressString;

@property (nonatomic, strong) NSString *numberString;

@end
