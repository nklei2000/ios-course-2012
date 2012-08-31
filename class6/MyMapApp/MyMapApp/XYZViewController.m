//
//  XYZViewController.m
//  MyMapApp
//
//  Created by Nam Kin Lei on 8/25/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "XYZViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "Pin.h"

@interface XYZViewController ()

-(void)initializeMapAnnotations;
-(void)removeCircleFromTargetPins;
-(void)circleTargetPinsWith:(NSMutableArray *)pinArray;

-(void)alertMeWhenNearOneOfPlaces;
-(void)playSound;

- (void) showPinDetails:(MKMapView *)mapView annotationView:(MKAnnotationView *)view;
- (void) showRoute:(MKMapView *)mapView annotationView:(MKAnnotationView *)view;

@end


BOOL okToPlaySound;

@implementation XYZViewController
@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
    NSLog(@"thePath: %@", thePath);

    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:thePath] error:&error];
    
    if ( error ) {
        NSLog(@"Error in init audio player: %@", [error localizedDescription]);
        okToPlaySound = NO;
    } else {
        self.audioPlayer.delegate = self;
        okToPlaySound = YES;
    }
        
    // Location
    if ( map.showsUserLocation == NO ) {
        map.showsUserLocation = YES;
    }
    [map setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [self.locationManager startUpdatingLocation];

#if (TARGET_IPHONE_SIMULATOR)
    NSLog(@"You are using iphone simulator");
    // CLLocationCoordinate2D location = CLLocationCoordinate2DMake(22.193438,113.538624);
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(22.193495,113.538575);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 5000, 5000);
    [map setRegion:region animated:TRUE];
#endif
    
    // Initialize map annotations
    [self initializeMapAnnotations];

}

- (void)viewDidUnload
{
    [self setMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
        
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)initializeMapAnnotations
{
    NSMutableArray *pinsArray = [[NSMutableArray alloc] initWithCapacity:13];
    {
        // 基督教會宣道堂 (總堂)
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.204312,113.545681);
        pin.title = @"基督教會宣道堂 (總堂)";
        pin.subtitle = @"高士德大馬路100號";
        
        pin.address = @"高士德大馬路100號";
        pin.tel = @"28212518, 28552719";
        pin.remarks = @"\n主日崇拜：上午九時、上午十一時、晚上八時 （粵語講道、國語即時傳譯)\n禱告會：禮拜三晚上八時\n少年團契：逢禮拜六　下午二時半\n中學生團契：逢禮拜三　下午五時正, 逢禮拜六　下午二時半\n大專生團契：逢禮拜六　晚上八時正\n青年團契：禮拜六晚上八時\n伉儷團契：逢二、四週禮拜六晚上八時正\n婦女小組：	逢禮拜四早上九時正逢禮拜六下午二時半\n長青團契：逢禮拜五早上九時正(團契)";
        
        pin.isHeadQuarter = YES;
        
        [pinsArray addObject:pin];
    }
    {
        // 美景宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.157296, 113.553419);
        pin.title = @"美景宣道堂";
        pin.subtitle = @"氹仔布拉干薩街47-J 美景花園第七座美都閣BD舖";
        
        pin.address = @"氹仔布拉干薩街47-J 美景花園第七座美都閣BD舖";
        pin.tel = @"28838651";
        pin.remarks = @"\n主日崇拜：逢禮拜日早上 11:00 (國語即時傳譯)\n逢禮拜日下午 2:30 (英語即時傳譯)\n青年團契：逢禮拜六晚上 8:00\n學生團契：逢禮拜六下午 3:00\n少年主日學：逢禮拜日早上 11:00\n童創新天地：逢禮拜六下午 2:45";
        
        [pinsArray addObject:pin];
    }
    {
        // 建華宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.208536, 113.553403);
        pin.title = @"建華宣道堂";
        pin.subtitle = @"黑沙環新填區勞動節街建華大廈第十一座地下B舖";
        
        pin.address = @"黑沙環新填區勞動節街建華大廈第十一座地下B舖";
        pin.tel = @"28451319";
        pin.remarks = @"\n主日崇拜：逢禮拜日早上11:00\n少年主日學：逢禮拜日早上11:00\n學生團契：逢禮拜六下午3:00\n少年團契：逢禮拜六下午2:45\n青年團契：逢禮拜六晚上8:00\n查經禱告會：逢禮拜四晚上8:30";
        
        [pinsArray addObject:pin];
    }
    {
        // 氹仔宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.153746, 113.556479);
        pin.title = @"氹仔宣道堂";
        pin.subtitle = @"氹仔山治米蘭打前地5號";
        
        pin.address = @"氹仔山治米蘭打前地5號";
        pin.tel = @"28827218";
        pin.remarks = @"\n主日崇拜：上午十時半\n學生團契：禮拜六下午三時正\n少年團契：禮拜六下午 2:30\n查經祈禱會：禮拜四晚上 8:30";
        
        [pinsArray addObject:pin];
    }
    {
        // 筷子基宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.208653, 113.544074);
        pin.title = @"筷子基宣道堂";
        pin.subtitle = @"筷子基和樂坊一街13號 宏興大廈一樓F-G座";
        
        pin.address = @"筷子基和樂坊一街13號 宏興大廈一樓F-G座";
        pin.tel = @"28550956";
        pin.remarks = @"\n主日崇拜：早上十時半\n查經禱告會：禮拜四晚上八時正\n少年團契：禮拜六下午二點半";
        
        [pinsArray addObject:pin];
    }
    {
        // 閩南宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.208507, 113.549884);
        pin.title = @"閩南宣道堂";
        pin.subtitle = @"黑沙灣慕拉士大馬路利添閣四樓U-V座";
        
        pin.address = @"黑沙灣慕拉士大馬路利添閣四樓U-V座";
        pin.tel = @"28531513";
        pin.remarks = @"\n主日崇拜：早上九時正,早上十一時正、晚上八時半\n查經禱告會：禮拜四晚上八時半\n青年團契：禮拜六晚上八時正";
        
        [pinsArray addObject:pin];
    }
    {
        // 沙梨頭宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.201332, 113.537725);
        pin.title = @"沙梨頭宣道堂";
        pin.subtitle = @"沙梨頭海邊街新昌工業大廈";
        
        pin.address = @"沙梨頭海邊街新昌工業大廈";
        pin.tel = @"28955854";
        pin.remarks = @"\n主日崇拜：上午十一時正\n查經禱告會：禮拜日下午四時十分";
        
        [pinsArray addObject:pin];
    }
    {
        // 下環宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.193370, 113.535802);
        pin.title = @"下環宣道堂";
        pin.subtitle = @"下環司打口11號新威大廈一樓B";
        
        pin.address = @"下環司打口11號新威大廈一樓B";
        pin.tel = @"28580899";
        pin.remarks = @"\n主日崇拜：上午十一時正、晚上八時正\n查經禱告會：禮拜四晚上八時正";
        
        [pinsArray addObject:pin];
    }
    {
        // 北區宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.210967,113.548996);
        pin.title = @"北區宣道堂";
        pin.subtitle = @"祐漢新村第四街38-46號,祐成工業大廈二樓D座";
        
        pin.address = @"祐漢新村第四街38-46號,祐成工業大廈二樓D座";
        pin.tel = @"28400144";
        pin.remarks = @"\n主日崇拜：上午十一時正";
        
        [pinsArray addObject:pin];
    }
    {
        // 新橋宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.202502,113.54115);
        pin.title = @"新橋宣道堂";
        pin.subtitle = @"大興街71號-73號地下及二樓";
        
        pin.address = @"大興街71號-73號地下及二樓";
        pin.tel = @"28300224";
        pin.remarks = @"\n主日崇拜：上午十一時正\n學生團契：禮拜五下午五點半\n青年團契：禮拜六晚上八時正";
        
        [pinsArray addObject:pin];
    }
    {
        // 祐漢宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.212735,113.550079);
        pin.title = @"祐漢宣道堂";
        pin.subtitle = @"祐漢新村第八街泉碧花園第一期三樓O-P座";
        
        pin.address = @"祐漢新村第八街泉碧花園第一期三樓O-P座";
        pin.tel = @"28437161";
        pin.remarks = @"\n主日崇拜：早上十時半、晚上八時正\n查經禱告會：禮拜三晚上八時半";
        
        [pinsArray addObject:pin];
    }
    {
        // 台山宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.2136,113.54781);
        pin.title = @"台山宣道堂";
        pin.subtitle = @"巴坡沙大馬路嶺南大廈一樓A-B座";
        
        pin.address = @"巴坡沙大馬路嶺南大廈一樓A-B座";
        pin.tel = @"28439242";
        pin.remarks = @"\n主日崇拜：早上十一時正\n中學生團契：逢禮拜六下午四時半\n青年聚會：禮拜六晚上八時正\n少年團契：禮拜六下午二時半\n禱告會：\n禮拜二下午六時正\n禮拜四晚上七時正\n禮拜六早上十一時正\n\n長者活動：逢每月第一週及第三週主日下午3時 正\n主內兄姊愛筵及活動：逢每月第四週主日崇拜之後舉行";
        
        [pinsArray addObject:pin];
    }
    {
        // 潮語宣道堂
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.206448,113.545064);
        pin.title = @"潮語宣道堂";
        pin.subtitle = @"提督馬路139-149號南益工業大厦二樓C";
        
        pin.address = @"提督馬路139-149號南益工業大厦二樓C";
        pin.tel = @"28573971";
        pin.remarks = @"\n主日崇拜：早上十時半\n少年團契：禮拜六下午二時半\n青年團契：禮拜六晚上八點\n大專團契：禮拜一晚上八點\n中學生團契：禮拜三下午五點半\n音樂團契：禮拜三下午三點";
        
        [pinsArray addObject:pin];
    }
    
    {
        // 我的住所
        // MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        Pin *pin = [[Pin alloc] init];
        pin.coordinate = CLLocationCoordinate2DMake(22.193495,113.538575);
        pin.title = @"我的住所";
        pin.subtitle = @"天通街11號中建大廈X樓X座";
        
        pin.address = @"天通街11號中建大廈X樓X座";
        pin.tel = @"+85366XXXX71";
        pin.remarks = @"";
        
        pin.isMyHomeLocationMark = YES;
        [pinsArray addObject:pin];
    }
    
    [map addAnnotations:pinsArray];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // User Location (Moving)
    if ( mapView.userLocation == annotation )
    {
        [mapView.userLocation setTitle:@"您在此"];
        return nil;
    }
    
    Pin *pin = (Pin*)annotation;
    
    NSString *identifier = @"church";
    
    if ( pin.isMyHomeLocationMark ) {
        identifier = @"my home";
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
    if ( pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    if ( pin.isMyHomeLocationMark )
    {
        UIImage *thumbnail = [UIImage imageNamed:@"MyHome.png"];
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnail];
        CGRect newBounds = CGRectMake(0.0, 0.0, 32.0, 32.0);
        [thumbnailImageView setBounds:newBounds];
        
        // pinView.leftCalloutAccessoryView = thumbnailImageView;
        pinView.rightCalloutAccessoryView = thumbnailImageView;
        pinView.pinColor = MKPinAnnotationColorRed;
        
    }
    else
    {
        pinView.pinColor = pin.isHeadQuarter? MKPinAnnotationColorPurple : MKPinAnnotationColorGreen;    
    }
        
    pinView.annotation = annotation;
    pinView.canShowCallout = YES;
    
    if ( !pin.isMyHomeLocationMark )
    {
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    pinView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    return pinView;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Tapped Pin with title: %@", view.annotation.title);
    
    Pin *pin = (Pin *)view.annotation;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:map.userLocation.coordinate.latitude longitude:map.userLocation.coordinate.longitude];

    // show my location
    NSLog(@"My Location (%f, %f)", myLocation.coordinate.latitude, myLocation.coordinate.longitude);

    CLLocationDistance distance = [myLocation distanceFromLocation:location];
    
    int distanceInt = distance;
    int kiloMeter = distanceInt/1000;
    int meter = distanceInt - kiloMeter*1000;
    
    NSLog(@"You are distance from there is %i km and %i m", kiloMeter, meter);
    
    [self removeCircleFromTargetPins];

    NSMutableArray *pinArray = [[NSMutableArray alloc] init];
    [pinArray addObject:pin];
    
    [self circleTargetPinsWith:pinArray];
}


- (void)removeCircleFromTargetPins
{
    // Remove all circled Pins
    if ( self.currentCircles != nil &&
        self.currentCircles.count > 0 )
    {
        for (int i=0; i < self.currentCircles.count; i++)
        {
            MKCircle *circle = (MKCircle *)[self.currentCircles objectAtIndex:i];
            [map removeOverlay:circle];
            [self.currentCircles removeObject:circle];
            circle = nil;
        }
        self.currentCircles = nil;
    }
}

- (void)circleTargetPinsWith:(NSMutableArray *)pinArray
{
    for ( int i = 0; i < pinArray.count; i++ )
    {
        Pin *pin = (Pin *)[pinArray objectAtIndex:i];
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:pin.coordinate radius:50];
        
        if ( self.currentCircles == nil ) {
            self.currentCircles = [[NSMutableArray alloc] init];
        }
        
        [self.currentCircles addObject:circle];
        
        [map addOverlay:circle];        
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (control == view.leftCalloutAccessoryView)
    {
        [self showPinDetails:mapView annotationView:view];
    }
    else
    {
        [self showRoute:mapView annotationView:view];
    }
}

- (void) showPinDetails:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
{
    NSLog(@"Detail Button is tapped on pin: %@", view.annotation.title);
    
    Pin *pin = (Pin*)view.annotation;
    
    NSLog(@"Location: (%f, %f)", pin.coordinate.latitude, pin.coordinate.longitude);
    NSLog(@"Address: %@", pin.address);
    NSLog(@"Tel: %@", pin.tel);
    NSLog(@"Remarks: %@", pin.remarks);
    
    if ( pin.isCurrentLocationMark )
    {
        NSLog(@"You are here!");
    }
    else
    {
        NSString *title = @"";
        NSString *message = @"";
        
        if ( pin.isMyHomeLocationMark )
        {
            title = @"關於我";
            message = [NSString stringWithFormat:@"地址：%@ \n電話：%@ %@", pin.address, pin.tel, pin.remarks];
        }
        else
        {
            title = @"教會資料";
            message = [NSString stringWithFormat:@"%@ \n\n地址：%@ \n電話：%@ %@", pin.title, pin.address, pin.tel, pin.remarks];
            
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"睇完"
                                                  otherButtonTitles:nil];
        
        UILabel *messageLabel = (UILabel*)[[alertView subviews] objectAtIndex:1];
        
        messageLabel.textAlignment = UITextAlignmentLeft;
        messageLabel.font = [UIFont systemFontOfSize:14.0];
        
        [alertView show];
    }

}

- (void) showRoute:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
{
    NSLog(@"I want to show a route to here");

    Pin *pin = (Pin*)view.annotation;
    
    CLLocationCoordinate2D userLocation = [map userLocation].coordinate;
    CLLocationCoordinate2D targetLocation = pin.coordinate;
        
    NSString *googleURL = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", userLocation.latitude,userLocation.longitude,
                           targetLocation.latitude,targetLocation.longitude];
    NSLog(@"Google Maps URL: %@", googleURL);
    
    [[UIApplication sharedApplication]openURL:[[NSURL alloc] initWithString:googleURL]];
    
}


- (void) alertMeWhenNearOneOfPlaces
{
    NSLog(@"Check if alert me when I walk close to one of the places");
    
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:map.userLocation.coordinate.latitude longitude:map.userLocation.coordinate.longitude];
    
    NSMutableArray *pinArray;
    
    [self removeCircleFromTargetPins];
    
    NSString *title = @"到達地點";
    NSString *message = @"";
    int distance = 0;
    
    
    NSArray *annoations = map.annotations;
    for (int i=0; i < annoations.count; i++)
    {
        Pin *pin = (Pin *)[annoations objectAtIndex:i];
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
        
        distance = [pinLocation distanceFromLocation:myLocation];

        // Range of 2meters ~ 10meters
        if ( distance >= 2 && distance < 10 )
        {
            NSLog(@"Found %@", pin.title);
            
            message = [NSString stringWithFormat:@"%@\n您距離%@只有 %i 米", message, pin.title, distance];
            
            if ( pinArray == nil ) {
                pinArray = [[NSMutableArray alloc] init];
            }
            
            [pinArray addObject:pin];
        }
    }
    
    if (pinArray != nil && pinArray.count > 0)
    {
        [self circleTargetPinsWith:pinArray];
        
        UIAlertView *alertView =
                [[UIAlertView alloc] initWithTitle:title
                                           message: message
                                          delegate:nil
                                 cancelButtonTitle:@"關閉"
                                 otherButtonTitles:nil];
        [self playSound];
        [alertView show];
    
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    
    return circleView;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if ( newLocation )
    {
        if ( (oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
             (oldLocation.coordinate.longitude != newLocation.coordinate.longitude) )
        {
            
//            map.centerCoordinate = newLocation.coordinate;
//            
//            Pin *pin = [[Pin alloc] init];
//            
//            pin.coordinate = newLocation.coordinate;
//            pin.title = @"您在此";
//            pin.subtitle = @"";
//            pin.address = @"";
//            pin.tel = @"";
//            pin.remarks = @"";
//            
//            pin.isCurrentLocationMark = YES;
//            
//            [map addAnnotation:pin];
//            // [self.locationManager stopUpdatingLocation];

            NSLog(@"Old Location (%f, %f), New Location (%f, %f)",
                  oldLocation.coordinate.latitude, oldLocation.coordinate.longitude,
                  newLocation.coordinate.latitude, newLocation.coordinate.longitude);
                        
            [self alertMeWhenNearOneOfPlaces];
            
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"GPS error %@", [error description]);
}


// Audion part
- (void)playSound
{
    NSLog(@"preparing to play sound...");
    if ( self.audioPlayer && okToPlaySound )
    {
        okToPlaySound = NO;
        
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        
         NSLog(@"Starting play sound...");
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Finished Playing");
    okToPlaySound = YES;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"Begin Interruption...");
    okToPlaySound = NO;
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    NSLog(@"End Interruption");
    okToPlaySound = YES;
}

@end
