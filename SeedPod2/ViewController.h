//
//  ViewController.h
//  SeedPod2
//
//  Created by Tobias Carlander on 5/15/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyCLController.h"
#import "KMLParser.h"


@interface ViewController : UIViewController <MyCLControllerDelegate, ZBarReaderDelegate >
{
    UITextView *resultText;
    MyCLController *locationController;
    NSString *mapType;
    KMLParser *kmlParser;
    NSString *scannedText;
    
}

@property (nonatomic) IBOutlet UITextView *resultText;
@property (nonatomic) IBOutlet MKMapView *TheMap;
@property (nonatomic) IBOutlet NSString *mapType;
@property (nonatomic) NSString *scannedText;
- (IBAction) openScanner;
- (void) scanButtonTapped;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end
