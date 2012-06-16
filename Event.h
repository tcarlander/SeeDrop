//
//  Event.h
//  SeeDrop
//
//  Created by Tobias Carlander on 16/06/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSDecimalNumber * fillStatus;
@property (nonatomic, retain) NSManagedObject *userRel;
@property (nonatomic, retain) Comment *comment;

@end
