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


@interface ViewController : UIViewController <MyCLControllerDelegate, ZBarReaderDelegate,MKMapViewDelegate,UITextViewDelegate >
{
    UITextView *resultText;
    MyCLController *locationController;
    NSString *whatMap;
    KMLParser *kmlParser;
    NSString *scannedText;
    int numberOfSeeds;
    int numberOfWater;
    NSUserDefaults *defaults;
    
    
    
}

@property (nonatomic) IBOutlet UITextView *resultText;
@property (nonatomic) IBOutlet MKMapView *TheMap;
@property (nonatomic) IBOutlet NSString *whatMap;
@property (nonatomic) NSString *scannedText;
@property (nonatomic) int numberOfSeeds;
@property (nonatomic) int numberOfWater;
@property (nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *levelWaterLable;
@property (weak, nonatomic) IBOutlet UILabel *numberSeedsLable;
@property (weak, nonatomic) IBOutlet UITextView *eventComment;
@property (nonatomic) CLLocationCoordinate2D newEventCoord;
- (void) scanButtonTapped;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (IBAction) openScanner;
- (IBAction)viewProfile:(id *)sender;
- (IBAction)saveNewEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *eventDetail;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UITextView *eventTitle;
- (IBAction)dismissScanner:(id)sender;
- (IBAction)reduseWater:(id)sender;

@end
