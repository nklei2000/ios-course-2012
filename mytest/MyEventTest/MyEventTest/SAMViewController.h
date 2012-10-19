//
//  SAMViewController.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface SAMViewController : UIViewController <EKEventEditViewDelegate, EKEventViewDelegate, EKCalendarChooserDelegate>
{

}

@property (strong, nonatomic) IBOutlet UITextField *eventTextField;

@property (strong, nonatomic) IBOutlet UIButton *localNotificationTest;

@property (strong, nonatomic) EKEventStore *eventStore;

- (IBAction)newEvent:(id)sender;
- (IBAction)editEvent:(id)sender;
- (IBAction)viewEvent:(id)sender;

- (IBAction)localNotificationTest:(id)sender;
- (IBAction)listEvents:(id)sender;

- (IBAction)showCamera:(id)sender;

@end
