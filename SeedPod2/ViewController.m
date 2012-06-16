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
@synthesize Details;

@synthesize  resultText,TheMap, whatMap,scannedText;


-(NSString *)mapType
{
    if (whatMap == NULL){
        whatMap = @"";
    }
    return whatMap;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[self whatMap]  isEqualToString:@""]){
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
    if ([[self whatMap]  isEqualToString:@"ReadBC"]){
        [self scanButtonTapped];
    } 
    if ([self TheMap]){
        TheMap.mapType = MKMapTypeHybrid;
        TheMap.delegate = self;
        if ([[self whatMap]  isEqualToString:@"Report"]){
            locationController = [[MyCLController alloc] init];
            locationController.delegate = self;
            locationController.running = TRUE;
            [locationController.locationManager startUpdatingLocation];

            [TheMap setShowsUserLocation:YES];
        } else {
                [self loadOverlayForMap];
        }
    }
    
    //self.mapType = @"";
}

- (void)viewDidUnload
{
    [self setDetails:nil];
    [super viewDidUnload];
    
}

-(void)loadOverlayForMap
{
    NSString *path =@"";
    NSURL *url;
    
    if ([whatMap  isEqualToString:@"Macro"]){
        path = [[NSBundle mainBundle] pathForResource:@"KML_Sample" ofType:@"kml"];
        url = [NSURL fileURLWithPath:path];
    }else
    if ([whatMap  isEqualToString:@"Culinary"]){
        path = [[NSBundle mainBundle] pathForResource:@"Events" ofType:@"kml"];
        url = [NSURL fileURLWithPath:path];
    }else
    if ([whatMap  isEqualToString:@"Cultural"]){
        path = [[NSBundle mainBundle] pathForResource:@"KML_Sample" ofType:@"kml"];
        url = [NSURL fileURLWithPath:path];
    }else
    if ([whatMap  isEqualToString:@"Worldly"]){
        path = [[NSBundle mainBundle] pathForResource:@"KML_Sample" ofType:@"kml"];
        url = [NSURL fileURLWithPath:path];
    }
    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
        
    // Add all of the MKOverlay objects parsed from the KML file to the map.
//    NSArray *overlays = [kmlParser overlays];
//    [TheMap addOverlays:overlays];
        
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kmlParser points];
    [TheMap addAnnotations:annotations];
        
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
/*    for (id <MKOverlay> overlay in overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
  */      
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
    vc.whatMap = [segue identifier];
    
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

#pragma mark MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
   // NSLog(@"here2");
    return [kmlParser viewForOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    UIImage *eventPin;
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:SFAnnotationIdentifier];

        if ([whatMap  isEqualToString:@"Macro"]){
            eventPin = [UIImage imageNamed:@"macroLeaf.png"];            
        }else if ([whatMap  isEqualToString:@"Culinary"]){
            eventPin = [UIImage imageNamed:@"culinaryLeaf.png"];
            }else
                if ([whatMap  isEqualToString:@"Cultural"]){
                    eventPin = [UIImage imageNamed:@"culturalLeaf.png"];
                }else
                    if ([whatMap  isEqualToString:@"Worldly"]){
                        eventPin = [UIImage imageNamed:@"worldlyLeafSmall.png"];
                    }
        // You may need to resize the image here.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;

        annotationView.canShowCallout = YES;
        annotationView.image = eventPin;
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
    
    //return [kmlParser viewForAnnotation:annotation];
}
- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
   
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation>  annotation = view.annotation;

    whatMap = annotation.subtitle;
    [self performSegueWithIdentifier: @"DetailsSegue" 
                              sender: self];
    NSLog(@"MapView %@",whatMap);
}

@end
