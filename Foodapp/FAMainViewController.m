//
//  FAMainViewController.m
//  Foodapp
//
//  Created by Larry Cao on 3/8/14.
//  Copyright (c) 2014 Foodapp Inc. All rights reserved.
//

#import "FAMainViewController.h"
#import "FAFoodProfileViewController.h"
#import "FAFoodCell.h"
#import "FoodApp.h"

NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString *kCellID = @"foodCell";                          // UICollectionViewCell storyboard id]

@interface FAMainViewController()

@property (nonatomic, strong) NSArray *foodData;

@end

@implementation FAMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"FoodApp";
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    
    if (![FoodApp hasUserConfig]) {
        [self performSegueWithIdentifier:@"showStartScreen" sender:self];
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        [self loadData];
    }
}

- (void)loadData {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://foodapp-dev.herokuapp.com/api/v1/user/1/foods"];
    
    NSLog(@"hello");
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *e;
            self.foodData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            NSLog(@"%@", self.foodData);
            [self.collectionView reloadData];
        });
    }] resume];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    return [self.foodData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    FAFoodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
//    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    
    NSMutableDictionary *food = self.foodData[indexPath.row];
    
    if (!food[@"thumbnail_data"]) {
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:food[@"thumbnail_url"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                food[@"thumbnail_data"] = [UIImage imageWithData:data];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
        }] resume];
        
    } else {
        cell.image.image = food[@"thumbnail_data"];
    }
        
//    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
//
    
    
    
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
//        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        FAFoodProfileViewController *foodProfileViewController = [segue destinationViewController];
        
        foodProfileViewController.image = [[(FAFoodCell *)sender image] image];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        
//        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
//        DetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.image = image;
        
    }
}

@end
