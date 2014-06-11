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

#import "DZNSegmentedControl.h"

NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString *kCellID = @"foodCell";                          // UICollectionViewCell storyboard id]

@interface FAMainViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *foodData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *appLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) BOOL scrollingDown;
@property (weak, nonatomic) IBOutlet UIImageView *topPicture;

@property (nonatomic) CGFloat lastContentOffset;

@end

@implementation FAMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"FoodApp"; // move to storyboard
    [self.tabBarController.tabBar setHidden:NO];
    
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)selectionChanged {
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.appLabel.font = [UIFont fontWithName:@"GiddyupStd" size:40];
    
    
    DZNSegmentedControl *segmentedControl = [[DZNSegmentedControl alloc] initWithItems:@[@"Near", @"Top"]];
    
    [segmentedControl setFrame:CGRectMake(0, 110, 320, 40)];
    
    segmentedControl.showsCount = NO;
    segmentedControl.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9];
    [segmentedControl addTarget:self action:@selector(selectionChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    
    
    //check if user is logged in and has saved userconfiguration. If not then show login screen.
    if (![FoodApp hasUserConfig]) {
        [self performSegueWithIdentifier:@"showStartScreen" sender:self];
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.scrollingDown = NO;
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
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
        foodProfileViewController.data = food;
    
        
        // load the image, to prevent it from being cached we use 'initWithContentsOfFile'
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%d_full", selectedIndexPath.row];
        
//        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageNameToLoad ofType:@"JPG"];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        
//        DetailViewController *detailViewController = [segue destinationViewController];
//        detailViewController.image = image;

    }
}


#pragma mark - ScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastContentOffset > scrollView.contentOffset.y + 15) {
        if (self.scrollingDown) {
            self.scrollingDown = NO;
            [self stopFullScreenScrolling];
        }
    } else if (self.lastContentOffset + 15 < scrollView.contentOffset.y) {
        if (!self.scrollingDown) {
            self.scrollingDown = YES;
            [self beginFullScreenScrolling];
        }
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)beginFullScreenScrolling {
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    
    CGFloat offsetY = height;
    
    [UIView animateWithDuration:.5 animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

- (void)stopFullScreenScrolling {
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    
    CGFloat offsetY = -height;
    [UIView animateWithDuration:.5 animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

@end
