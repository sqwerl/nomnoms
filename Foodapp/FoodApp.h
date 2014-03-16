//
//  FoodApp.h
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodApp : NSObject

+ (BOOL)hasUserConfig;
+ (void)loadUserConfigWithLogin:(NSString *)login userID:(NSString *)userID authToken:(NSString *)authToken;
//+ (void)updateUserConfigWithLogin:(NSString *)login;
//+ (void)updateUserConfigWithAuthToken:(NSString *)authToken;
+ (void)clearUserConfig;

//+ (NSString *)userLogin;
//+ (NSString *)userID;
//+ (NSString *)authToken;



@end
