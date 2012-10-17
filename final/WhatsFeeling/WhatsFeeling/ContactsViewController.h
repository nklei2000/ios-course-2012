//
//  ContactsViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/16/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class DataModel;
@class FeelingPerson;

@interface ContactsViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,ABUnknownPersonViewControllerDelegate>
{

}

@property (assign, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *filteredDataArray;

@property (strong, nonatomic) NSMutableArray *indiceArray;
@property (strong, nonatomic) NSMutableArray *filteredIndexArray;

@property (strong, nonatomic) IBOutlet UITableView *contactsTbl;

@property (assign, nonatomic) bool isFiltered;

- (IBAction)unknownPerson:(id)sender;

- (IBAction)pickABPerson:(id)sender;

- (IBAction)createNewPerson:(id)sender;
- (IBAction)listPersons:(id)sender;
- (IBAction)editPerson:(id)sender;



@end
