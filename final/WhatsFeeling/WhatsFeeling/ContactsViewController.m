//
//  ContactsViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/16/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>

#import "ContactsViewController.h"

#import "FeelingPerson.h"
#import "MyCommon.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
@synthesize contactsTbl;


static NSString *sectionDataKey = @"SectionData";
static NSString *sectionTitleKey = @"SectionTitle";

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
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 68)];
	
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
    
//    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchController.searchResultsDataSource = self;
//    searchController.searchResultsDelegate = self;
    
//    headerView.layer.cornerRadius = 5.0;
//    headerView.layer.borderWidth = 3.0;
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.78 alpha:1.0].CGColor;
//    headerView.layer.shadowColor = [UIColor grayColor].CGColor;
//    headerView.layer.shadowRadius = 6.0f;
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowOffset = CGSizeMake(0, 3);
    headerView.layer.shadowOpacity = 0.5f;
   
    
	contactsTbl.tableHeaderView = headerView;
    
    // self.dataArray = [[NSMutableArray alloc] init];
    // self.filteredDataArray = [[NSMutableArray alloc] init];
    self.isFiltered = FALSE;
    
    self.dataArray = [NSMutableArray array];    
    [self initIndiceArrays];
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



- (void)initIndiceArrays
{
    self.indiceArray = [NSMutableArray arrayWithObjects:
                        @"A", @"B", @"C", @"D", @"E", @"F", @"G",
                        @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                        @"O", @"O", @"P", @"Q", @"R", @"S", @"T",
                        @"U", @"V", @"W", @"X", @"Y", @"Z", @"#",
                        nil];
    
    for ( int i = 0; i < [self.indiceArray count]; i++ )
    {
        NSMutableDictionary *section = [[NSMutableDictionary alloc] init];
        NSMutableArray *sectionDataArray = [[NSMutableArray alloc] init];
        
        NSLog(@"initIndiceArrays (%d): %@", i, [self.indiceArray objectAtIndex:i]);
        [section setValue:[self.indiceArray objectAtIndex:i] forKey:sectionTitleKey];
        [section setValue:sectionDataArray forKey:sectionDataKey];
        
        [self.dataArray addObject:section];
        
    }
    
    self.filteredIndiceArray = [NSMutableArray array];
    
}


- (void) duplicateAddressBookContactItems
{
    NSLog( @"Entering duplicateAddressBookContactItems..." );
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *peopleArray = (NSMutableArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    NSLog( @"People array: %d", [peopleArray count] );
    
//  NSMutableArray *allNames = [NSMutableArray array];
    
//    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
//    
//    CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(people)), (CFComparatorFunction)ABPersonComparePeopleByName, (void*)ABPersonGetSortOrdering());
//    
//    NSArray *peopleArray = (NSMutableArray *)CFBridgingRelease(peopleMutable);
        
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
                
        // [self.dataArray addObject:feelingPerson];
        [self indexContactsItem:feelingPerson
                           data:self.dataArray
                         indice:self.indiceArray];
        
    }
    
    [self sortTableViewDataArray];
    
}

- (void)indexContactsItem:(FeelingPerson *)person data:(NSMutableArray*) theDataArray indice:(NSMutableArray *)theIndiceArray
{
    NSLog(@"Index contacts item");
        
    if ( person != nil )
    {
        NSString *firstChar = [[person.fullName uppercaseString]
                               substringWithRange:NSMakeRange(0,1)];
        // UniChar firstChar = [person.fullName characterAtIndex:0];
        NSLog(@"index string: %@", firstChar );
        
        NSMutableArray *sectionDataArray;

        NSLog(@"indice array count: %d", [self.indiceArray count]);
        
        NSUInteger location;
        NSUInteger defaultLocation = [self.indiceArray indexOfObject:@"#"];
        
        if ( [MyCommon isNumeric:firstChar] ) {
            location = [self.indiceArray indexOfObject:@"#"];
        } else {
            location = [self.indiceArray indexOfObject:firstChar];
        }
              
        NSLog(@"location: %d, unknownLoacation: %d", location, defaultLocation);
        if ( location == NSNotFound )
        {
            // sectionDataArray = [[self.dataArray lastObject] valueForKey:@"sectionData"];
            location = defaultLocation;
            NSLog(@"location is not found, replaced with defalut location: %d", defaultLocation);
        }
        
        if ( location != NSNotFound )
        {
            sectionDataArray = [[self.dataArray objectAtIndex:location] objectForKey:sectionDataKey];
                        
            if (sectionDataArray != nil)
            {
                NSLog(@"sectionDataArray count: %d", [sectionDataArray count]);
                
                [sectionDataArray addObject:person];
                int index = [sectionDataArray count] - 1;
                NSLog(@"Added into row %d of sectionDataArray", index );
            }
            else
            {
                NSLog(@"sectionDataArray is nil");
            }
        }
        else
        {
            NSLog(@"location is not found");
        }
    }
}

-(void)sortTableViewDataArray
{
    for ( int i = 0; i < [self.dataArray count]; i++ )
    {
        NSLog(@"processing: %d", i);
        NSMutableArray *sectionDataArray = [[self.dataArray objectAtIndex:i] objectForKey:sectionDataKey];
        
        if ( sectionDataArray != nil && [sectionDataArray count] )
        {
            [MyCommon sortTheNSArray:sectionDataArray forKey:@"fullName"];
        }
    }
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"numberOfSectionsInTableView...");
    
    if ( self.isFiltered )
    {
        return 1;
    }
    else
    {
        return [self.dataArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection...");
    
    if ( self.isFiltered ) {
        return [self.filteredDataArray count];
    } else {
        // return [self.dataArray count];
        return [[[self.dataArray objectAtIndex:section] objectForKey:sectionDataKey] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath...");
    
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
        // feelingPerson = (FeelingPerson*)[self.dataArray objectAtIndex:indexPath.row];
        feelingPerson = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:sectionDataKey] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = feelingPerson.fullName;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection...");
    
    if ( self.isFiltered )
    {
        return nil;
    }
    else
    {
        NSArray *theDataArray = [[self.dataArray objectAtIndex:section] objectForKey:sectionDataKey];
        if ( theDataArray != nil && [theDataArray count] ) {
            return [[self.dataArray objectAtIndex:section] objectForKey:sectionTitleKey];
        } else {
            return nil;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //NSLog(@"sectionIndexTitlesForTableView...");
    
    if ( self.isFiltered ) {
        return self.filteredIndiceArray;
    } else {
        return self.indiceArray;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //NSLog(@"sectionForSectionIndexTitle...");
    
    if ( self.isFiltered ) {
        return [self.filteredIndiceArray indexOfObject:title];
    } else {
        return [self.indiceArray indexOfObject:title];
    }
}


#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [FeelingTableViewCell heightForCellWithFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath...");
    
    FeelingPerson *selectedFeelingPerson;
    
    if ( self.isFiltered )
    {
        selectedFeelingPerson = [self.filteredDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        selectedFeelingPerson = [[[self.dataArray objectAtIndex:indexPath.section] objectForKey:sectionDataKey] objectAtIndex:indexPath.row];
    }
    
    NSLog(@"Selected: %@", selectedFeelingPerson );
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        
        self.filteredDataArray = [NSMutableArray array];
        
        for ( int i=0; i < [self.dataArray count]; i++)
        {            
            NSMutableArray *sectionDataArray = [[self.dataArray objectAtIndex:i] objectForKey:sectionDataKey];
            
            if ( sectionDataArray != nil && [sectionDataArray count])
            {                
                for (FeelingPerson *person in sectionDataArray)
                {
                    NSRange nameRange = [person.fullName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    NSRange phoneRange = [person.phoneNumber rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    
                    if (nameRange.location != NSNotFound || phoneRange.location != NSNotFound)
                    {
                        [self.filteredDataArray addObject:person];
                    }
                }
            }
        }
        
        if ( self.filteredIndiceArray != nil && [self.filteredIndiceArray count])
        {
            [MyCommon sortTheNSArray:self.filteredIndiceArray forKey:@"fullName"];
        }
    }
    
    NSLog(@"preparing reload table data");
    
    [self.contactsTbl reloadData];
    
}


#pragma mark - Test Actions

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

@end
