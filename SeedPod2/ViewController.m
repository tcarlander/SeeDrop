//
//  ViewController.m
//  SeeDrop
//
//  Created by Tobias Carlander on 5/15/12.
//  Copyright (c) 2012 WFP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize  resultText,TheMap, mapType,scannedText;


-(NSString *)mapType
{
    if (mapType == NULL){
        mapType = @"";
    }
    return mapType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self mapType]  isEqualToString:@""]){
        self.navigationController.navigationBarHidden = YES;
    }else {
        self.navigationController.navigationBarHidden = NO;
    }
if ([[self mapType]  isEqualToString:@"ReadBC"]){
    [self scanButtonTapped];
}
    if ([[self mapType]  isEqualToString:@"Report"]){
        locationController = [[MyCLController alloc] init];
        locationController.delegate = self;
        locationController.running = TRUE;
        [locationController.locationManager startUpdatingLocation];
        [TheMap setShowsUserLocation:YES];
    }
    if ([[self mapType]  isEqualToString:@"Macro"]){

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Events" ofType:@"kml"];
        NSURL *url = [NSURL fileURLWithPath:path];
        kmlParser = [[KMLParser alloc] initWithURL:url];
        [kmlParser parseKML];
        
        // Add all of the MKOverlay objects parsed from the KML file to the map.
        NSArray *overlays = [kmlParser overlays];
        [TheMap addOverlays:overlays];
        
        // Add all of the MKAnnotation objects parsed from the KML file to the map.
        NSArray *annotations = [kmlParser points];
        [TheMap addAnnotations:annotations];
        
        // Walk the list of overlays and annotations and create a MKMapRect that
        // bounds all of them and store it into flyTo.
        MKMapRect flyTo = MKMapRectNull;
        for (id <MKOverlay> overlay in overlays) {
            if (MKMapRectIsNull(flyTo)) {
                flyTo = [overlay boundingMapRect];
            } else {
                flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
            }
        }
        
        for (id <MKAnnotation> annotation in annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(flyTo)) {
                flyTo = pointRect;
            } else {
                flyTo = MKMapRectUnion(flyTo, pointRect);
            }
        }
        
        // Position the map so that all overlays and annotations are visible on screen.
        TheMap.visibleMapRect = flyTo;

    }
    
    self.mapType = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


//Segue code



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"PFS %@",[segue identifier]);
    ViewController *vc = [segue destinationViewController];
    vc.mapType = [segue identifier];
}


// Barcode Code

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];

}

- (IBAction) openScanner
{
[self performSegueWithIdentifier: @"ReadBC" 
                          sender: self];
}

- (void) scanButtonTapped
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentModalViewController: reader
                            animated: YES];

    
}

- (void)locationUpdate:(CLLocation *)location 
{
    //locationLabel.text =  [NSString stringWithFormat:@"%g %g",location.coordinate.latitude,location.coordinate.longitude] ;
    MKCoordinateRegion region;
	region.center=location.coordinate;
    MKCoordinateSpan span;
	span.latitudeDelta=.005;
	span.longitudeDelta=.005;
	region.span=span;
    //[self addEvent];
	[TheMap setRegion:region animated:TRUE];
    [locationController.locationManager stopUpdatingLocation];
   // NSLog(@"Got Here");
    
}

- (void)locationError:(NSError *)error 
{
    //locationLabel.text = [error description];
}

//Ma=pping 


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    return [kmlParser viewForOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [kmlParser viewForAnnotation:annotation];
}

@end
