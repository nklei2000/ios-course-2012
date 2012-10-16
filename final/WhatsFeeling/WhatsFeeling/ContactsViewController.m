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

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSArray *peopleArray = (NSMutableArray *)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    // NSMutableArray *allNames = [NSMutableArray array];
    
//    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
//    
//    CFArraySortValues(peopleMutable, CFRangeMake(0, CFArrayGetCount(people)), (CFComparatorFunction)ABPersonComparePeopleByName, (void*)ABPersonGetSortOrdering());
//    
//    NSMutableArray *peoples = (NSMutableArray *)CFBridgingRelease(peopleMutable);
    
    for (id person in peopleArray)
    {
        NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonFirstNameProperty));
        
        NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(person), kABPersonLastNameProperty));
                
        ABMutableMultiValueRef multiValueEmail = ABRecordCopyValue(CFBridgingRetain(person), kABPersonEmailProperty);
        
        if (ABMultiValueGetCount(multiValueEmail) > 0)
        {
            NSString *email = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValueEmail, 0));
            
            NSLog(@"email: %@", email);
        }
        
        NSLog(@"Full name: %@ %@" , firstName, lastName);
        
        ABMutableMultiValueRef multiValuePhoneNumber = ABRecordCopyValue(CFBridgingRetain(person), kABPersonPhoneProperty);
        
        if ( ABMultiValueGetCount(multiValuePhoneNumber) > 0 )
        {
            for ( int i=0; i < ABMultiValueGetCount(multiValuePhoneNumber); i++)
            {
                NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValuePhoneNumber, i));
                
                NSString *label = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiValuePhoneNumber,i));
                
                NSLog(@"%@: %@", label, phone);
            }
        }
        
//        if (![firstName length]) {
//            firstName = @"";
//        }
//        if (![lastName length]) lastName = @"";
//        
//        [allNames addObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
        
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

@end
