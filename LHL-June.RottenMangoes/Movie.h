//
//  Movie.h
//  LHL-June.RottenMangoes
//
//  Created by Asuka Nakagawa on 2016-07-18.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

// title, synopsis, posters
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *synopsis;
@property (nonatomic) NSString *postersURLStr;

@property (nonatomic) NSString *movieID;
@property (nonatomic) Movie *review;
@property (nonatomic) NSString *critic;
@property (nonatomic) NSString *quote;

@end
