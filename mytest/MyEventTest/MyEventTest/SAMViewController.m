//
//  SAMViewController.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SAMViewController.h"
#import "CameraViewController.h"

#import <EventKit/EventKit.h>

@interface SAMViewController ()

@end

@implementation SAMViewController
@synthesize eventTextField;
@synthesize localNotificationTest;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.eventStore = [[EKEventStore alloc] init];
}

- (void)viewDidUnload
{
    [self setEventTextField:nil];
    [self setLocalNotificationTest:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)newEvent:(id)sender
{
    // EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = eventTextField.text;
    event.startDate = [NSDate date];
    event.endDate = [NSDate date];
    event.allDay = YES;
    
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    
    NSError *error;
    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    
    NSLog(@"error.code: %d, error: %@, noErr: %d", error.code, error, noErr);
    if ( error.code == noErr )
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Event Created"
                                                             message:@"Completed"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}

- (IBAction)editEvent:(id)sender
{
    
    EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init];
    eventEditViewController.eventStore = self.eventStore;
    eventEditViewController.editViewDelegate = self;
    
    [self presentModalViewController:eventEditViewController animated:YES];
    
    
}

- (IBAction)viewEvent:(id)sender {
    
    EKEventViewController *eventViewController = [[EKEventViewController alloc] init];
    eventViewController.delegate = self;
    eventViewController.allowsEditing = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eventViewController];
    
    [self presentModalViewController:navigationController animated:YES];
    
}

- (IBAction)listEvents:(id)sender
{
    NSLog(@"listEvents...");
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents toDate:[NSDate date] options:0];
    
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents toDate:[NSDate date] options:0];
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:oneDayAgo endDate:oneYearFromNow calendars:nil];
    
    
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
    if ( events != nil )
    {
        NSLog(@"event count: %d", [events count]);
        for ( int i= 0; i < [events count]; i++)
        {
            EKEvent *event = [events objectAtIndex:i];
            NSLog(@"Event. title: %@, start date: %@, end date: %@",
                  event.title, event.startDate, event.endDate);
        }
        
    } else {
        NSLog(@"no event");
    }
    
//    
//    self.kalViewController = [[KalViewController alloc] init];
//    self.kalViewController.title = @"NativeCal";
//    
//    /*
//     *    Kal Configuration
//     *
//     */
//    self.kalViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];
//    self.kalViewController.delegate = self;
//    dataSource = [[EventKitDataSource alloc] init];
//    self.kalViewController.dataSource = dataSource;
//    
//    UINavigationController *modalController = [[UINavigationController alloc] initWithRootViewController:self.kalViewController];
//    [self presentViewController:modalController animated:YES completion:nil];
    
    
                                  
//                                  initWithStyle:EKCalendarChooserSelectionStyleSingle
//                                                             displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly
//                                                               eventStore:self.eventStore];
    
//    [chooser setEditing:YES];
//    [chooser setShowsDoneButton:YES];
//    [chooser setShowsCancelButton:YES];
//    
//    UINavigationController *modalController = [[UINavigationController alloc] initWithRootViewController:chooser];
//    [self presentViewController:modalController animated:YES completion:nil];
    
}


- (IBAction)showCamera:(id)sender {

    CameraViewController *cameraViewController = [[CameraViewController alloc] init];
    
    [self presentModalViewController:cameraViewController animated:YES];
    
}

- (IBAction)localNotificationTest:(id)sender {
    NSLog(@"local notification test");
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if ( localNotification != nil )
    {
        
        // NSDate *now = [NSDate date];
        
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = @"Time is up, thanks!";
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = @"View it";
        
        localNotification.applicationIconBadgeNumber = 1;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"name" forKey:@"test-key"];
        localNotification.userInfo = userInfo;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    [eventTextField resignFirstResponder];
    [localNotificationTest resignFirstResponder];
    
    
    
}

#pragma mark - Event
- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
    NSLog(@"eventViewController did complete");
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action;
{
    NSLog(@"eventEditViewController did complete");
    [controller dismissModalViewControllerAnimated:YES];
}



//- (void)didPresentAlertView:(UIAlertView *)alertView
//{
//    [txtListingPassword becomeFirstResponder];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [txtListingPassword resignFirstResponder];
//}


/*
- (void) saveEventWithDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    AppData *theData = [self theAppData];
 
    EKEventStore *eventStore = [[EKEventStore alloc] init];
 
    if([self checkIsDeviceVersionHigherThanRequiredVersion:@"6.0"])
    {
         [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted )
             {
                 
                 EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 
                 if ([defaults objectForKey:@"Calendar"] == nil) // Create Calendar if Needed
                 {
                     EKSource *theSource = nil;
                     
                     for (EKSource *source in eventStore.sources)
                     {
                         if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
                         {
                             theSource = source;
                             NSLog(@"iCloud Store Source");
                             break;
                         }
                         else
                         {
                             for (EKSource *source in eventStore.sources)
                             {
                                 if (source.sourceType == EKSourceTypeLocal)
                                 {
                                     theSource = source;
                                     NSLog(@"iPhone Local Store Source");
                                     break;
                                 }
                             }
                         }
                     }
                     
                     EKCalendar *cal;
                     cal = [EKCalendar calendarWithEventStore:eventStore];
                     cal.title = @"Repairs";
                     cal.source = theSource;
                     [eventStore saveCalendar:cal commit:YES error:nil];
 
                     NSLog(@"cal id = %@", cal.calendarIdentifier);
 
                     NSString *calendar_id = cal.calendarIdentifier;
                     [defaults setObject:calendar_id forKey:@"Calendar"];
                     event.calendar  = cal;
                     
                 }
                 else
                 {
                     event.calendar  = [eventStore calendarWithIdentifier:[defaults objectForKey:@"Calendar"]];
                     NSLog(@"Calendar Existed");
                 }
                 
                 event.title     = [NSString stringWithFormat:@"%@ iPhone Repair",[theData.repair_info objectForKey:@"name"]];
                 event.location  = @"Location of Repair";
                 event.notes     = @"Repair Notes";
                 event.startDate = startDate;
                 event.endDate   = endDate;
                 event.allDay    = NO;
                 EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-1800]; // Half Hour Before
                 event.alarms = [NSArray arrayWithObject:alarm];
                 
                 [eventStore saveEvent:event span:EKSpanThisEvent error:nil];
                 
             }
             else
             {
                 NSLog(@"Not Granted");
             }
             
         }];
     }
}
*/ 


/*
// Add event
EKEventStore *eventStore = [[EKEventStore alloc] init];
EKEvent *newEvent = [EKEvent eventWithEventStore:eventStore];
newEvent.title = @"Test";
newEvent.availability = EKEventAvailabilityFree;
newEvent.startDate = startDate;
newEvent.endDate = endDate;
[newEvent addAlarm:[EKAlarm alarmWithRelativeOffset:-15*60]];

newEvent.calendar = [eventStore defaultCalendarForNewEvents];

NSError *err;
BOOL success = [eventStore saveEvent:newEvent span:EKSpanThisEvent commit:YES error:&err];

if (success) {
    if ([newEvent respondsToSelector:@selector(calendarItemIdentifier)]) {
        [[NSUserDefaults standardUserDefaults] setObject:newEvent.calendarItemIdentifier forKey:self.showId];
        NSLog(@"Event ID: %@",newEvent.calendarItemIdentifier);
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:newEvent.UUID forKey:self.showId];
        NSLog(@"Event ID: %@",newEvent.UUID);
    }
}

// remove event
EKEventStore *eventStore = [[EKEventStore alloc] init];

NSError *err;
BOOL success = YES;

NSLog(@"Event ID: %@",[[NSUserDefaults standardUserDefaults] objectForKey:self.showId]);

EKEvent *existingEvent = [eventStore eventWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:self.showId]];
NSLog(@"Existing event: %@",existingEvent);
if (existingEvent != nil) {
    success = [eventStore removeEvent:existingEvent span:EKSpanThisEvent error:&err];
}
if (success) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.showId];
}

// remove event 2
NSPredicate *predicateForEvents = [eventStore predicateForEventsWithStartDate:nil endDate:nil calendars:[NSArray arrayWithObject:[eventStore defaultCalendarForNewEvents]]];
//set predicate to search for an event of the calendar(you can set the startdate, enddate and check in the calendars other than the default Calendar)

NSArray *events_Array = [eventStore eventsMatchingPredicate: predicateForEvents];
//get array of events from the eventStore

for (EKEvent *eventToCheck in events_Array)
{
    if ([eventToCheck.title isEqualToString: @"yourEventTitle")
    {
        NSError *err;
        BOOL success = [eventStore removeEvent:eventToCheck span:EKSpanThisEvent error:&err];
        NSLog(@"event deleted success if value = 1 : %d", success);
        
        break;
    }
}
*/
         
@end
