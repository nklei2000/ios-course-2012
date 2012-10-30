//
//  CoreDataViewController.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/30/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CoreDataViewController.h"
#import "PersonInfo.h"

@interface CoreDataViewController ()

@end

@implementation CoreDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // self.dataArray = [[NSMutableArray alloc] init];
    [self initCoreData];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] init];
    self.fetchedResultsController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyDataTbl:nil];
    [self setNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setGenderSegment:nil];
    [self setAgeTextField:nil];
    [super viewDidUnload];
}

- (IBAction)addPerson:(id)sender {
        
    if ([self addPersonInfo])
    {
        NSLog(@"Added person info");
        
        if ( [self fetchPeople] )
        {
            [self.myDataTbl reloadData];
        }
    }
    
}

- (IBAction)refreshData:(id)sender
{
    if ( [self fetchPeople] )
    {
        [self.myDataTbl reloadData];
    }
}

- (IBAction)removeData:(id)sender
{
    [self removeObjects];
    [self.myDataTbl reloadData];
}


- (void) initCoreData
{
    NSError *error;
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    if ( ![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
}

- (BOOL)addPersonInfo
{
    NSLog(@"Adding person info");
    
    int i = 1;
    for (NSString *name in [@"Sam*Joe*Justin*Tim" componentsSeparatedByString:@"*"])
    {
        NSLog(@"name: %@", name);
        
        PersonInfo *personInfo = (PersonInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"PersonInfo" inManagedObjectContext:self.managedObjectContext];
        
        personInfo.name = name;
        personInfo.lastName = @"TEST";
        
        personInfo.gender = (i%2==1? @"M": @"F");

        personInfo.birthDate = [NSDate date];
        
        ++i;
    }
    
    NSError *error;
    
    if ( ![self.managedObjectContext save:&error] )
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
        return FALSE;
    }
    
    return TRUE;
    
}


- (BOOL)fetchPeople
{
    NSLog(@"Fetching people info..." );
    
    if ( self.managedObjectContext == nil )
    {
        NSLog(@"db context object is null");
        return FALSE;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"PersonInfo" inManagedObjectContext:self.managedObjectContext]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:nil];
    
    NSArray *decriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:decriptors];
    
    
    NSError __autoreleasing *error;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"gender" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    if ( ![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
        return FALSE;
    }
    
    NSLog(@"section count: %d", [[self.fetchedResultsController sections] count]);
    return TRUE;
    
}

- (void)removeObjects
{
    NSError *error = nil;
    
    for (PersonInfo *personInfo in
         self.fetchedResultsController.fetchedObjects)
    {
        NSLog(@"deleting %@", personInfo.name);
        [self.managedObjectContext deleteObject:personInfo];
    }
    
    if ( ![self.managedObjectContext save:&error])
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
        return;
    }
    
    BOOL fetched = [self fetchPeople];
    NSLog( @"fetched: %@", (fetched?@"YES":@"NO") );
    
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles = [self.fetchedResultsController sectionIndexTitles];
    
    if ( titles.count <= section ) return @"Error";
    
    return [titles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return [[self.fetchedResultsController sectionIndexTitles] indexOfObject:title];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [managedObject valueForKey:@"name"];

    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100.0f;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"name: %@", [managedObject valueForKey:@"name"]);
    NSLog(@"last name: %@", [managedObject valueForKey:@"lastName"]);
    NSLog(@"gender: %@", [managedObject valueForKey:@"gender"]);
    NSLog(@"birth date: %@", [managedObject valueForKey:@"birthDate"]);

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; // no reordering allowed
}


@end
