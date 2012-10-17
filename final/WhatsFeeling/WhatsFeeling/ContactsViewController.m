//
//  ContactsViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/16/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ContactsViewController.h"

#import "FeelingPerson.h"
#import "MyCommon.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
@synthesize contactsTbl;

static NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"CONTACTS", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"contacts"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	/*
	 Create header with two buttons
	 */
	CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 55)];
	
	UILabel *phoneLabel = [[UILabel alloc] init];
	phoneLabel.frame = CGRectMake(0, 0, contactsTbl.frame.size.width, 25);
    phoneLabel.text = [NSString stringWithFormat:@"My Number is %@", [MyCommon getMyPhoneNumber]];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textColor = [UIColor lightGrayColor];
    phoneLabel.textAlignment = UITextAlignmentCenter;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, phoneLabel.frame.size.height, contactsTbl.frame.size.width, 40);
    searchBar.delegate = (id)self;
    
	[headerView addSubview:phoneLabel];
	[headerView addSubview:searchBar];
    
	contactsTbl.tableHeaderView = headerView;
    
    // self.dataArray = [[NSMutableArray alloc] init];
    // self.filteredDataArray = [[NSMutableArray alloc] init];
    self.isFiltered = FALSE;
    
    [self duplicateAddressBookContactItems];
    
}

- (void)viewDidUnload
{
    [self setContactsTbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.dataArray = nil;
    self.filteredDataArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)unknownPerson:(id)sender
{
    NSLog(@"Unknown person");
    
    ABRecordRef aContact = ABPersonCreate();
    CFErrorRef anError = NULL;
    ABMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    bool didAdd = ABMultiValueAddValueAndLabel(email, @"John-Appleseed@mac.com", kABOtherLabel, NULL);
    
    if (didAdd == YES)
    {
        ABRecordSetValue(aContact, kABPersonEmailProperty, email, &anError);
        if (anError == NULL)
        {
            ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
            picker.unknownPersonViewDelegate = self;
            picker.displayedPerson = aContact;
            picker.allowsAddingToAddressBook = YES;
            picker.allowsActions = YES;
            picker.alternateName = @"John Appleseed";
            picker.title = @"John Appleseed";
            picker.message = @"Company, Inc";
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:picker];
            
            [self presentModalViewController:navController animated:YES];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Could not create unknown user"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

- (IBAction)pickABPerson:(id)sender
{
    NSLog(@"Pick a AB Person");
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
    
}

- (IBAction)createNewPerson:(id)sender
{
    NSLog(@"Create a AB Person");
    
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:picker];
    
    [self presentModalViewController:navController animated:YES];
    
}

- (IBAction)listPersons:(id)sender
{
    NSLog(@"List AB Persons");
    
    [self duplicateAddressBookContactItems];
}

- (void) duplicateAddressBookContactItems
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
//    NSArray *peopleArray = (NSMutableArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
//  NSMutableArray *allNames = [NSMutableArray array];
    
    self.dataArray = [NSMutableArray array];
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
    
    CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(people)), (CFComparatorFunction)ABPersonComparePeopleByName, (void*)ABPersonGetSortOrdering());
    
    NSArray *peopleArray = (NSMutableArray *)CFBridgingRelease(peopleMutable);
        
    for (id person in peopleArray)
    {
        FeelingPerson *feelingPerson = [[FeelingPerson alloc] init];
        
        feelingPerson.firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonFirstNameProperty));
        
        feelingPerson.lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonLastNameProperty));
                
        ABMutableMultiValueRef multiValueEmail = ABRecordCopyValue(CFBridgingRetain(person), kABPersonEmailProperty);
        
        if (ABMultiValueGetCount(multiValueEmail) > 0)
        {
            feelingPerson.email = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValueEmail, 0));
            
            NSLog(@"email: %@", feelingPerson.email);
        }
        
        NSLog(@"Full name: %@ %@" , feelingPerson.firstName, feelingPerson.lastName);
        
        ABMutableMultiValueRef multiValuePhoneNumber = ABRecordCopyValue(CFBridgingRetain(person), kABPersonPhoneProperty);
        
        if ( ABMultiValueGetCount(multiValuePhoneNumber) > 0 )
        {
            feelingPerson.phoneNumber = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValuePhoneNumber, 0));
            
            for ( int i=0; i < ABMultiValueGetCount(multiValuePhoneNumber); i++)
            {
                NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValuePhoneNumber, i));
                
                NSString *label = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiValuePhoneNumber,i));
                
                NSLog(@"%@: %@", label, phone);
            }
        }
                
        [self.dataArray addObject:feelingPerson];
        
    }
    
}

- (void)changePerson
{
    NSLog(@"Change Person");
    
}



- (IBAction)editPerson:(id)sender
{
    
    NSLog(@"Edit AB Persons");
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *people = (NSArray *)CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, CFSTR("Sam")));
    
    NSLog(@"people: %@", people);
    
    if ( (people != nil) && [people count])
    {
        NSLog(@"people");
        
        ABRecordRef person = (ABRecordRef)CFBridgingRetain([people objectAtIndex:0]);
        ABPersonViewController *picker = [[ABPersonViewController alloc] init];
        picker.personViewDelegate = self;
        picker.displayedPerson = person;
        // Allow users to edit the person’s information
        picker.allowsEditing = YES;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:picker];
        
        [self presentModalViewController:navController animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Could not find Sam in the Contacts application"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    return NO;
}


#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark ABUnknownPersonViewControllerDelegate methods
// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.isFiltered )
        return [self.filteredDataArray count];
    else
        return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeelingPersonCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    FeelingPerson *feelingPerson;
    
    if ( self.isFiltered )
    {
        feelingPerson = (FeelingPerson*)[self.filteredDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        feelingPerson = (FeelingPerson*)[self.dataArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = feelingPerson.fullName;
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return @"Happy";
//    }
//    else if (section == 1)
//    {
//        return @"Upset";
//    }
//    else if (section == 2)
//    {
//        return @"Boring";
//    }
//    return @"";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [FeelingTableViewCell heightForCellWithFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected: %@", [self.dataArray objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeelingPerson *selectedFeelingPerson = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"Selected Feeling person: %@", [selectedFeelingPerson fullName]);
    
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText
{
    if ( searchText.length == 0 )
    {
        self.isFiltered = FALSE;
    }
    else
    {
        self.isFiltered = TRUE;
        
        self.filteredDataArray = [[NSMutableArray alloc] init];
        
        for (FeelingPerson *person in self.dataArray)
        {
            NSRange nameRange = [person.fullName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange phoneRange = [person.phoneNumber rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (nameRange.location != NSNotFound || phoneRange.location != NSNotFound)
            {
                [self.filteredDataArray addObject:person];
            }
        }
    }
    
    [self.contactsTbl reloadData];
    
}


@end
