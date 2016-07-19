//
//  MovieCollectionViewCell.h
//  LHL-June.RottenMangoes
//
//  Created by Asuka Nakagawa on 2016-07-18.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@property (strong, nonatomic) NSURLSessionTask *task;


@end
