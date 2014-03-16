//
//  FoodApp.m
//  Foodapp
//
//  Created by Larry Cao on 3/15/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FoodApp.h"

@interface FoodApp()

+ (void)loadConfig;

@end

@implementation FoodApp


static NSString *USER_LOGIN;
static NSString *USER_ID;
static NSString *AUTH_TOKEN;

+ (void)initialize {
    if (self == [FoodApp class]) {
        [FoodApp loadConfig];
    }
}

+ (void)loadConfig {
    @synchronized([FoodApp class]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        USER_LOGIN = [userDefaults stringForKey:@"user_login"];
        
        USER_ID = [userDefaults stringForKey:@"user_id"];
        
        AUTH_TOKEN = [userDefaults stringForKey:@"auth_token"];
    }
}

+ (BOOL)hasUserConfig {
    @synchronized([FoodApp class]) {
        return USER_LOGIN && USER_ID && AUTH_TOKEN;
    }
}

+ (void)loadUserConfigWithLogin:(NSString *)login userID:(NSString *)userID authToken:(NSString *)authToken {
    @synchronized([FoodApp class]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:login forKey:@"user_login"];
        [defaults setObject:userID forKey:@"user_id"];
        [defaults setObject:authToken forKey:@"auth_token"];
    }
}

+ (void)clearUserConfig {
    @synchronized([FoodApp class]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"user_login"];
        [defaults removeObjectForKey:@"user_id"];
        [defaults removeObjectForKey:@"auth_token"];
    }
}


@end
