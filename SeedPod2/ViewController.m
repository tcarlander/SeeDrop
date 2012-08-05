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
@synthesize eventDetail;
@synthesize eventDescription;
@synthesize eventTitle;
@synthesize firstName;
@synthesize lastName;
@synthesize levelWaterLable;
@synthesize numberSeedsLable;
@synthesize eventComment;
@synthesize  resultText,TheMap, whatMap,scannedText,newEventCoord,numberOfSeeds,numberOfWater,defaults;


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
    defaults = [NSUserDefaults standardUserDefaults];
    // load seeds & water
    numberOfSeeds = [defaults integerForKey:@"numberSeeds"];
    numberOfWater= [defaults integerForKey:@"numberWater"];
    levelWaterLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfWater];
    numberSeedsLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfSeeds];
    
    if ([[self whatMap]  isEqualToString:@""]){
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
    if ([[self whatMap]  isEqualToString:@"ReadBC"]){
        [self scanButtonTapped];
    } 
    if ([self TheMap]){
        //TheMap.mapType = MKMapTypeHybrid;
        TheMap.delegate = self;
        if (([[self whatMap]  isEqualToString:@"WorldlyCreate"]) || ( [[self whatMap]  isEqualToString:@"CulturalCreate"]) || ( [[self whatMap]  isEqualToString:@"CulinaryCreate"]) || ( [[self whatMap]  isEqualToString:@"MacroCreate"])){
            [self showReportMap];
        } else {
                [self loadOverlayForMap];
        }
    }
    eventComment.delegate = self;
    eventDetail.delegate = self;
    eventDescription.delegate = self;
    eventTitle.delegate = self;
    
    //self.mapType = @"";
}

-(void)viewDidAppear{
    
    numberOfSeeds = [defaults integerForKey:@"numberSeeds"];
    numberOfWater= [defaults integerForKey:@"numberWater"];
    levelWaterLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfWater];
    numberSeedsLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfSeeds];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    numberOfSeeds = [defaults integerForKey:@"numberSeeds"];
    numberOfWater= [defaults integerForKey:@"numberWater"];
    levelWaterLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfWater];
    numberSeedsLable.text = [[NSString alloc]initWithFormat:@"%d", numberOfSeeds];
    
}
-(void)showReportMap{
    
    locationController = [[MyCLController alloc] init];
    locationController.delegate = self;
    locationController.running = TRUE;
    [locationController.locationManager startUpdatingLocation];
    //[TheMap setShowsUserLocation:YES];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.TheMap addGestureRecognizer:lpgr];
    NSLog(@"Init Map");
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) return;
    NSLog(@"Flip Map");
    CGPoint touchPoint = [gestureRecognizer locationInView:self.TheMap];
    NSLog(@"Here:%f",touchPoint.x);
    CLLocationCoordinate2D touchMapCoordinate = [self.TheMap convertPoint:touchPoint toCoordinateFromView:self.TheMap];
    NSLog(@"Here:%f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    newEventCoord = touchMapCoordinate;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    point.title = @"New Event";
    point.subtitle = @"this is a fun event";
    [TheMap addAnnotation:point];
    [self performSegueWithIdentifier: @"MakeEvent" 
                              sender: self];
}

- (void)viewDidUnload
{
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setLevelWaterLable:nil];
    [self setNumberSeedsLable:nil];
    [self setEventComment:nil];
    [self setEventDetail:nil];
    [self setEventDescription:nil];
    [self setEventTitle:nil];
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
    vc.newEventCoord = self.newEventCoord;
    
    
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
        break;
    
    NSLog(@"Code Read");
    resultText.text = symbol.data;
    if([resultText.text isEqualToString:@"Recharge!!"]){
        NSLog(@"Recharged");
        // Save new Water & Seed
        numberOfSeeds +=1;
        numberOfWater +=1;
        [defaults setObject:@(numberOfSeeds) forKey:@"numberSeeds"];
        [defaults setObject:@(numberOfWater) forKey:@"numberWater"];
        [defaults synchronize];
        [reader dismissModalViewControllerAnimated: YES];
        [[self navigationController]popViewControllerAnimated:NO];
        
    }
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];

}

- (IBAction) openScanner
{
    NSLog(@"Open Scanner");
[self performSegueWithIdentifier: @"ReadBC" 
                          sender: self];

}

- (IBAction)viewProfile:(id *)sender {

}

- (IBAction)saveNewEvent:(id)sender {
    CLLocationCoordinate2D coord = self.newEventCoord;
    NSLog(@"%f", coord.latitude);
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = @"New Event";
    point.subtitle = @"this is a fun event";
    // Save new Water & Seed
    numberOfSeeds -=1;
    [defaults setObject:@(numberOfSeeds) forKey:@"numberSeeds"];
    [defaults synchronize];
    [self dismissModalViewControllerAnimated:YES];
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

        if ([whatMap  isEqualToString:@"Macro"]){            eventPin = [UIImage imageNamed:@"macroLeaf.png"];   }else if ([whatMap  isEqualToString:@"Culinary"]){
            eventPin = [UIImage imageNamed:@"culinaryLeaf.png"];
            }else
                if ([whatMap  isEqualToString:@"Cultural"]){
                    eventPin = [UIImage imageNamed:@"culturalLeaf.png"];
                }else
                    if ([whatMap  isEqualToString:@"Worldly"]){
                        eventPin = [UIImage imageNamed:@"worldlyLeafSmall.png"];
                    }else {
                        eventPin = [UIImage imageNamed:@"worldlyLeafSmall.png"]; 
                    }
        // You may need to resize the image here.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside 
         ];
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
    NSLog(@"showDetail on %@",self);
   
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id <MKAnnotation>  annotation = view.annotation;

    whatMap = annotation.subtitle;
    [self performSegueWithIdentifier: @"DetailsSegue" 
                              sender: self];
    NSLog(@"MapView %@",view);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {  
    BOOL shouldChangeText = YES;  
    
    if ([text isEqualToString:@"\n"]) {  
        // Find the next entry field  
        [textView resignFirstResponder];
        shouldChangeText = NO;  
    }  
    return shouldChangeText; 
}


- (IBAction)dismissScanner:(id)sender {
    [sender dismissModalViewControllerAnimated: YES];

}

- (IBAction)reduseWater:(id)sender {
    numberOfWater -=1;
    [defaults setObject:@(numberOfSeeds) forKey:@"numberWater"];
    [defaults synchronize];

    
}
@end
