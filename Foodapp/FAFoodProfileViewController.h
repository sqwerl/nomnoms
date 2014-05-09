//
//  FAFoodProfileViewController.h
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDescriptionView : UIView


@property (nonatomic, weak) IBOutlet UILabel *dishname;

@property (nonatomic, weak) IBOutlet UILabel *details;

@property (nonatomic, weak) IBOutlet UILabel *description;


@end

@interface RestaurantDescriptionView : UIView

@property (nonatomic, weak) IBOutlet UILabel *restaurantName;

@property (nonatomic, weak) IBOutlet UILabel *restaurantDetails;

@end


@interface FAFoodProfileViewController :UIViewController


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSDictionary *data;

@end
