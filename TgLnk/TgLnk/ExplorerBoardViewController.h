//
//  ExplorerBoardViewController.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/30/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SystemUIViewControllerModel.h"
#import "DatabaseModel.h"
#import "BoardDetailTableViewController.h"

@protocol mapViewDelegate <NSObject>

-(void)getClickedCoordinates;


@optional
-(void)getClickedStatus:(BOOL)status;

@end

@interface ExplorerBoardViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocationManager *locationManager;
}


@property (retain, nonatomic) IBOutlet MKMapView *map;
@property  (assign,nonatomic) id mapViewDelegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (weak, nonatomic) IBOutlet UIButton *clsoe;

@property (weak, nonatomic) IBOutlet UIButton *myPositions;

@end
