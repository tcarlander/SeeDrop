//
//  Comment.h
//  SeeDrop
//
//  Created by Tobias Carlander on 16/06/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSManagedObject *event;
@property (nonatomic, retain) NSManagedObject *user;

@end
