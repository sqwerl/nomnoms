//
//  FARestaurantMenuContentViewController.m
//  NomNom
//
//  Created by Larry Cao on 5/25/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FARestaurantMenuContentViewController.h"

#import "FAFoodCell.h"
#import "FoodApp.h"


@interface FARestaurantMenuContentViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic) NSUInteger pageIndex;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation FARestaurantMenuContentViewController

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
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlString = [NSString stringWithFormat:@"http://foodapp-dev.herokuapp.com/api/v1/user/%@/foods", [FoodApp userID]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:[NSString stringWithFormat:@"Token token=%@", [FoodApp authToken]] forHTTPHeaderField:@"Authorization"];
    
    
    NSLog(@"hello");
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *e;
            self.data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSLog(@"%@", self.data);
            [self.collectionView reloadData];
        });
    }] resume];
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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FAFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    

    NSMutableDictionary *food = self.data[indexPath.row];
    
    
    
    if (!food[@"thumbnail_data"]) {
        
        if (cell.image.image) {
            cell.image.image = nil;
            cell.likes.text = nil;
            cell.heart.hidden = YES;
        }
        
        if (![cell.activityIndicator isAnimating]) {
            [cell.activityIndicator startAnimating];
        }
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:food[@"thumbnail_url"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    food[@"thumbnail_data"] = image;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            });
            
        }] resume];
        
    } else {
        if ([cell.activityIndicator isAnimating]) {
            [cell.activityIndicator stopAnimating];
        }
        cell.image.image = food[@"thumbnail_data"];
        cell.likes.text = [NSString stringWithFormat:@"%@", food[@"likes"]];
        cell.heart.hidden = NO;
        NSLog(@"%@", food[@"likes"]);
        
    }
    //    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    //
    
    return cell;
}

#pragma mark - UICollectionViewDelegate



@end
