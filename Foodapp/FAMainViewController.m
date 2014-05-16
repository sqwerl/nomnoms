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
    self.navigationItem.title = @"FoodApp"; // move to storyboard
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    
//    if (![FoodApp hasUserConfig]) {
        [self performSegueWithIdentifier:@"showStartScreen" sender:self];
        [self.tabBarController.tabBar setHidden:YES];
//    } else {
//        [self loadData];
//    }
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
        cell.image.image = nil;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [activityIndicator startAnimating];
        
        [cell addSubview:activityIndicator];
        
        activityIndicator.frame = CGRectOffset(activityIndicator.frame, cell.bounds.size.width/2 - activityIndicator.bounds.size.width/2, cell.bounds.size.height/2 - activityIndicator.bounds.size.width/2);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:food[@"thumbnail_url"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:data];
                
                if (image) {
                    food[@"thumbnail_data"] = image;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }

                [activityIndicator stopAnimating];

            });
            
        }] resume];
        
    } else {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
                
                
                [view removeFromSuperview];
            }
        }
        cell.image.image = food[@"thumbnail_data"];
    }
    
    
    
    
        
//    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
//
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
        
        NSDictionary *food = self.foodData[[self.collectionView indexPathForCell:(UICollectionViewCell *)sender].row];
        foodProfileViewController.data = food[@"restaurant"];
        
        foodProfileViewController.name = food[@"name"];
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        
//        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
//        DetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.image = image;
        
    }
}

@end
