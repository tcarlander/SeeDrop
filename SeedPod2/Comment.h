//
//  Comment.h
//  SeeDrop
//
//  Created by Tobias Carlander on 17/06/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;

@end
