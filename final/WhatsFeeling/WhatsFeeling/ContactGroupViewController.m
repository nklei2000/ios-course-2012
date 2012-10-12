//
//  ContactGroupViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "ContactGroupViewController.h"
#import "FeelingViewController.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"

#import "DataModel.h"
#import "ContactGroup.h"
#import "MyCommon.h"

@interface ContactGroupViewController ()

@end

@implementation ContactGroupViewController
@synthesize contactGroupTbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Feeling", @"Feeling");
        self.tabBarItem.image = [UIImage imageNamed:@"heart"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	/*
	 Set the background color
	 */
	contactGroupTbl.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
	
	/*
	 Create header with two buttons
	 */
	CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 55)];
	
	UIButton *newGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[newGroupButton addTarget:self action:@selector(addNewContactGroup) forControlEvents:UIControlEventTouchUpInside];
	newGroupButton.frame = CGRectMake(10, 5, 90, 30);
	[newGroupButton setTitle:NSLocalizedString(@"New Group",nil) forState:UIControlStateNormal];
    [[newGroupButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
	        
	[headerView addSubview:newGroupButton];
	
	contactGroupTbl.tableHeaderView = headerView;
    
    // Change backgroud size: 320x460(480)
//    contactGroupTbl.backgroundView = nil;
//    [contactGroupTbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-contact-group.png"]]];
    
    // Localized the lables and buttons
    [MyCommon replaceTextWithLocalizedTextInSubviewsForView:self.view];
 
    self.feelingViewController = [[FeelingViewController alloc] initWithNibName:@"FeelingViewController" bundle:nil];
    self.feelingViewController.dataModel = self.dataModel;
    
    self.dataArray = [[NSMutableArray alloc] init];
    isDataLoaded = NO;
    
}

- (void)viewDidUnload
{
    [self setContactGroupTbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // we need to call this every time when the view shows.
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // we need to call this every time when the view shows.
    self.navigationController.navigationBarHidden = NO;
    
    if ( !isDataLoaded ) {
        [self loadContactGroupFromNetwork];
    }
    else
    {
        [contactGroupTbl reloadData];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addNewContactGroup
{
    NSLog( @"Added new contact group!" );
    [MyCommon ShowInfoAlert:@"Implement later"];
}

- (void)parseJson:(id)JSON
{
    if ( [self.dataArray count] > 0 ) {
        [self.dataArray removeAllObjects];
    }
    
    NSString *appLanguage = [MyCommon checkAppLanguage];
    NSLog(@"Language (current): %@", appLanguage);
    
    NSDictionary* item;
    NSEnumerator *enumerator = [JSON objectEnumerator];
    while (item = (NSDictionary*)[enumerator nextObject])
    {
        ContactGroup *group = [[ContactGroup alloc]init];
        NSLog(@"group id: %@", [item objectForKey:@"id"]);
        NSLog(@"name: %@", [item objectForKey:@"name"]);
        NSLog(@"creation user: %@", [item objectForKey:@"creation_user"]);
        
        group.groupId = [item objectForKey:@"id"];
        group.name = [item objectForKey:@"name"];
        group.creationUser = [item objectForKey:@"creation_user"];

        [self.dataArray addObject:group];

    }
    NSLog(@"%d objects loaded", [self.dataArray count]);
    [contactGroupTbl reloadData];
    
    isDataLoaded = YES;
    
}

- (void) loadContactGroupFromNetwork
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Loading", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"contactgroup", @"cmd",
                            nil];
    
    NSLog(@"%@", params);
    
    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net/"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    NSURLRequest *request = [client requestWithMethod:@"POST"
                                                 path:@"/api.php"
                                           parameters:params];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         // Do something with JSON
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"%@", @"loaded contact group");

             NSLog(@"Json: %@", JSON);
             [self parseJson:JSON];
             
         }
     }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSLog(@"Json: %@", JSON);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MyCommon ShowErrorAlert:[error localizedDescription]];
         }
         
     }];
    
    // you can either start your operation like this
    [operation start];
    
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactGroupCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
//        UISwitch *switchView = [[UISwitch alloc] init];
//        [switchView addTarget:self action:@selector(switchViewToggled:) forControlEvents:UIControlEventValueChanged];
//        switchView.tag = indexPath.row;
//        
//        cell.accessoryView = switchView;
        
    }
    
    ContactGroup *group = (ContactGroup*)[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = group.name;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    cell.accessoryView = button;
    
    return cell;
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
    
    ContactGroup *selectedContactGroup = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"Selected contactGroup name: %@", [selectedContactGroup name]);
    
    // save the selection
    [[NSUserDefaults standardUserDefaults] setValue:selectedContactGroup.groupId forKey:@"SelectedContactGroupKey"];
    [[NSUserDefaults standardUserDefaults] setValue:selectedContactGroup.name forKey:@"SelectedContactGroupValue"];
    
    // and force the OS to save the changes to disk.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.feelingViewController.title = selectedContactGroup.name;
    [self.navigationController pushViewController:self.feelingViewController animated:YES];
    
}

@end
