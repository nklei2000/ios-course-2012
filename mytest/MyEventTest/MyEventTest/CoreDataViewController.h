//
//  CoreDataViewController.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/30/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;
@class NSManagedObjectContext;

@interface CoreDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate>
{

}

@property (strong, nonatomic) IBOutlet UITableView *myDataTbl;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;

- (IBAction)addPerson:(id)sender;

// @property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)refreshData:(id)sender;
- (IBAction)removeData:(id)sender;

@end
