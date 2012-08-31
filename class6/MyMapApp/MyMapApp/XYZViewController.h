//
//  XYZViewController.h
//  MyMapApp
//
//  Created by Nam Kin Lei on 8/25/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>


@interface XYZViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet MKMapView *map;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSMutableArray *currentCircles;
@end
