//
//  ExplorerBoardViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/30/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ExplorerBoardViewController.h"

@interface ExplorerBoardViewController (){

    NSMutableArray *nsNewArray ;
    BOOL myPosition;
    
}

@end

@implementation ExplorerBoardViewController

@synthesize mapViewDelegate;
@synthesize map;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.clsoe
    = [SystemUIViewControllerModel styleButton:self.clsoe
                                  cornerRadius:7.0f borderWidth:1.0f borderColor:[RGB2UICOLOR(255,255,255,1) CGColor]];
    self.myPositions = [SystemUIViewControllerModel styleButton:self.myPositions
                                                  cornerRadius:7.0f borderWidth:1.0f borderColor:[RGB2UICOLOR(255,255,255,1) CGColor]];
    
    
    [self getGPSBoard];
    
    self.map.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 5000.0f;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];
    self.map.showsUserLocation = YES;
    [self.map setMapType:MKMapTypeStandard];
    [self.map setZoomEnabled:YES];
    [self.map setScrollEnabled:YES];
}



- (IBAction)myLocation:(id)sender {
    if (myPosition) {
        myPosition = NO;
    }else{
        myPosition = YES;

    }
    [self.loading setHidden:NO];
    [self.loading startAnimating];
    
    [locationManager startUpdatingLocation];
}


- (NSMutableArray *)accordingToSubtitleReturnBoard:(NSString *)bid{
    NSMutableArray *tempMultiArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[nsNewArray count]; i++) {
        if ([bid isEqualToString:[NSString stringWithString:nsNewArray[i][@"BID"]]]) {
            
            [tempMultiArray addObject:nsNewArray[i]];
            break;
        }
    }
    
    return tempMultiArray;

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc]init];

    annotationView.canShowCallout = YES;
    annotationPoint = annotation;
     UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.tag = [annotationPoint.subtitle intValue];
    [button addTarget:self action:@selector(boardDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView = button;
    return annotationView;
}


-(void)boardDetail:(UIButton *)sender{

    NSLog(@"%@",[self accordingToSubtitleReturnBoard:[NSString stringWithFormat:@"%ld",(long)sender.tag]]);
    

}







- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [mapView deselectAnnotation:view.annotation animated:YES];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //append the drops and pins
    for (int i=0; i<[nsNewArray count]; i++) {
        NSArray *location = [[NSString stringWithString:nsNewArray[i][@"BGPS"]] componentsSeparatedByString:@","];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocation *cllocation = [[CLLocation alloc] initWithLatitude:[location[0] doubleValue] longitude:[location[1] doubleValue]];
        
        point.title = nsNewArray[i][@"BNAME"];
        point.subtitle = nsNewArray[i][@"BID"];
        
        [UIView animateWithDuration:0.5f
                         animations:^(void){
                             point.coordinate  = cllocation.coordinate;
                             [self.map addAnnotation:point];

                         }];
    }
    
    //set the default position
    NSArray *defaultLocation = [[NSString stringWithString:nsNewArray[0][@"BGPS"]] componentsSeparatedByString:@","];

    
    MKCoordinateRegion region;
    if (myPosition) {
        //set the default region
        region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000);
    }
    else{
        
        //set the default region
        region = MKCoordinateRegionMakeWithDistance([[CLLocation alloc] initWithLatitude:[defaultLocation[0] doubleValue] longitude:[defaultLocation[1] doubleValue]].coordinate, 10000, 10000);
    
    }
   
    
    //set the map region
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
}



-(void)getGPSBoard{
    NSMutableArray *nsMutaArray = [[DatabaseModel queryBoard] copy];
    nsNewArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[nsMutaArray count]; i++) {
        if (![[nsMutaArray objectAtIndex:i][@"BGPS"] isEqualToString:@""]) {
            [nsNewArray addObject:[nsMutaArray objectAtIndex:i]];
        }
    }
}



-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.loading startAnimating];

}

- (IBAction)close:(id)sender {
    
    [mapViewDelegate getClickedStatus:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{

    [self.loading stopAnimating];
    [self.loading setHidden:YES];


}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}






@end
