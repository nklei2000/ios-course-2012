//
//  Pin.h
//  MyMapApp
//
//  Created by Nam Kin Lei on 8/26/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pin : NSObject <MKAnnotation>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

// add extra data
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *remarks;

@property (nonatomic) BOOL isCurrentLocationMark;
@property (nonatomic) BOOL isHeadQuarter;

@property (nonatomic) BOOL isMyHomeLocationMark;

@end
