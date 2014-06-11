//
//  FAProfileViewController.m
//  Foodapp
//
//  Created by Larry Cao on 5/7/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FAProfileViewController.h"
#import "FoodApp.h"

#import "FAfoodCell.h"

#define SAVED_FOODS_URL @""

@interface FAProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *listControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *formatControl;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSArray *foodData;

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
    
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [session dataTaskWithURL:url];
    
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
            self.foodData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSLog(@"%@", self.foodData);
            [self.collectionView reloadData];
        });
    }] resume];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
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


#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    return [self.foodData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    FAFoodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    //    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    
    NSMutableDictionary *food = self.foodData[indexPath.row];
    
    
    
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



@end
