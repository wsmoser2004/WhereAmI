//
//  WhereAmIViewController.m
//  WhereAmI
//
//  Created by Moser, Wesley on 1/27/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "WhereAmIViewController.h"
#import "BNRMapPoint.h"

@interface WhereAmIViewController ()

@end

@implementation WhereAmIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:50];
    [locationManager startUpdatingLocation];
    //[locationManager startUpdatingHeading];
    [worldView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord
                                                        title:[locationTitleField text]];
    
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:YES];
    
    // Reset the UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:[locations count] - 1];
    NSLog(@"%@", [location description]);
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[location timestamp] timeIntervalSinceNow];
    
    // CLLocationManager will return the last found location of the device first,
    // you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180)
    {
        // This is cached data, you don't want it, keep looking
        return;
    }
    
    [self foundLocation:location];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
//{
//    NSLog(@"New heading: %@", [newHeading description]);
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"Could not find the location %@", [error localizedDescription]);
//}
//
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
//    [worldView setRegion:region animated:YES];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    [textField resignFirstResponder];
    return YES;
}

@end
