//
//  User.h
//  SeeDrop
//
//  Created by Tobias Carlander on 17/06/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Event;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) Event *events;
@property (nonatomic, retain) Comment *comments;

@end
