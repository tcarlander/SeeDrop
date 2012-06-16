//
//  MapLeaf.h
//  SeeDrop
//
//  Created by Tobias Carlander on 15/06/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLeaf : MKShape  <MKAnnotation>
{
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
    
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic) CLLocationCoordinate2D coordinate;
-(void)setCoordinate:(CLLocationCoordinate2D)point;

@end
