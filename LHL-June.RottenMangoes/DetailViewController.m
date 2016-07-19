//
//  DetailViewController.m
//  LHL-June.RottenMangoes
//
//  Created by Asuka Nakagawa on 2016-07-18.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *review1TextView;
@property (weak, nonatomic) IBOutlet UILabel *critic1Label;

@property (weak, nonatomic) IBOutlet UITextView *review2TextView;
@property (weak, nonatomic) IBOutlet UILabel *critic2Label;

@property (weak, nonatomic) IBOutlet UITextView *review3TextView;
@property (weak, nonatomic) IBOutlet UILabel *critic3Label;

@property (nonatomic) NSMutableArray *reviewList;

@end

@implementation DetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.movie.title;
    self.reviewList = [NSMutableArray new];
    
    // 3 reviews
    NSString *urlReviewStr = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=3", self.movie.movieID];
    
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLSessionTask *reviewTask = [session1 dataTaskWithURL:[NSURL URLWithString:urlReviewStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            
            NSDictionary *reviewJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

            NSArray *reviewArray = reviewJSON[@"reviews"];

            NSMutableArray *reviews = [NSMutableArray array];
            
            for (NSDictionary *reviewDict in reviewArray) {

                Movie *reviewObject = [[Movie alloc] init];
                
                reviewObject.critic = reviewDict[@"critic"];
                reviewObject.quote = reviewDict[@"quote"];

                [reviews addObject:reviewObject];
                
//                NSLog(@"critic:%@, quote: %@", reviewObject.critic, reviewObject.quote);
                
            }

            self.reviewList = reviews;
            

            dispatch_async(dispatch_get_main_queue(), ^{

                [self updateReviews];
            });
        }
    }];
    // 3.All of the the different tasks from NSURLSession start in a suspended state. Start the task here.
    [reviewTask resume];
}

- (void)updateReviews {
    
    if (self.reviewList.count > 0) {
        Movie *review1 = [self.reviewList firstObject];
        self.review1TextView.text = review1.quote;
        self.critic1Label.text = review1.critic;
    }
    if (self.reviewList.count > 1) {
        Movie *review2 = [self.reviewList objectAtIndex:1];
        self.review2TextView.text = review2.quote;
        self.critic2Label.text = review2.critic;
    }
    
    if (self.reviewList.count > 2) {
        Movie *review3 = [self.reviewList objectAtIndex:2];
        self.review3TextView.text = review3.quote;
        self.critic3Label.text = review3.critic;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
