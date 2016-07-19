//
//  MainCollectionViewController.m
//  LHL-June.RottenMangoes
//
//  Created by Asuka Nakagawa on 2016-07-18.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "Movie.h"
#import "MovieCollectionViewCell.h"
#import "DetailViewController.h"

@interface MainCollectionViewController ()

@property (nonatomic) NSArray *moviesList;

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=xe4xau69pxaah5tmuryvrw75&page_limit=50";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *jsonError = nil;
        
        
        NSDictionary *wholeJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *movies = wholeJson[@"movies"];
        
        NSMutableArray *movieArray = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary *movieDict in movies) {
            
            
            Movie *movie = [[Movie alloc] init];

            movie.title = movieDict[@"title"];
            movie.synopsis = movieDict[@"synopsis"];
            movie.movieID = movieDict[@"id"];
            

            NSDictionary *postersDict = movieDict[@"posters"];
//            // NSURL
            movie.postersURLStr = postersDict[@"thumbnail"];
            
            [movieArray addObject:movie];
        }
        
        [self.collectionView reloadData];
        self.moviesList = movieArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

//        NSLog(@"inside completionHandler");
    }];
    
    [dataTask resume];
//    NSLog(@"outside completionHandler");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailViewController *dvc= segue.destinationViewController;
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    
    Movie *movieSelect = [self.moviesList objectAtIndex:indexPath.item];
    
    dvc.movie = movieSelect;
    

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.moviesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Movie *movieObject = [self.moviesList objectAtIndex:indexPath.item];
//        UIImage *thumbnail = [UIImage imageWithData:data];
    cell.titleLabel.text = movieObject.title;
    cell.synopsisLabel.text = movieObject.synopsis;
    
    
    [cell.task cancel]; // stop previous download
    cell.thumbnail.image = nil; // make sure previous poster isn't seen for a moment before our download finishes
    
    // url -> UIImage
    NSURL *url = [NSURL URLWithString:movieObject.postersURLStr];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // behind the cell, DL image from URL
    NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        UIImage *imageFromURL = [UIImage imageWithData:data]; // image from the data
        
        // tell the cell in MainVC to display the image
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.thumbnail.image = imageFromURL;
        });
        
    }];
    cell.task = dataTask; // save task on cell.
    [dataTask resume];
    
    
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
