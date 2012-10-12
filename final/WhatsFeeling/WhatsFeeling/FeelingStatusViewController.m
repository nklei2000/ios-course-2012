//
//  FeelingStatusViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/10/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "FeelingStatusViewController.h"

#import "DataModel.h"
#import "FeelingStatus.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"

#import "MyCommon.h"

@interface FeelingStatusViewController ()

@end

@implementation FeelingStatusViewController
@synthesize feelingStatusTbl;

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
    
    NSLog(@"FeelintStatusViewController view did load");
    
    self.dataArray = [[NSMutableArray alloc] init];    
    isDataLoaded = NO;
    
    self.navigationItem.title = NSLocalizedString(@"Choose your feeling", nil);
}

- (void)viewDidUnload
{
    [self setFeelingStatusTbl:nil];
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
        [self loadFeelStatusFromNetwork];
    }
    else
    {
        [feelingStatusTbl reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)loadFeelingStatuses
//{
//    self.dataArray = [[NSMutableArray alloc] initWithCapacity:5];
//    FeelingStatus *feelingStatus1 = [[FeelingStatus alloc] init];
//    feelingStatus1.code = @"HAPPY-001";
//    feelingStatus1.feeling = @"Happy";
//    [self.dataArray addObject:feelingStatus1];
//    
//    FeelingStatus *feelingStatus2 = [[FeelingStatus alloc] init];
//    feelingStatus2.code = @"HAPPY-002";
//    feelingStatus2.feeling = @"Happy very much";
//    [self.dataArray addObject:feelingStatus2];
//    
//    FeelingStatus *feelingStatus3 = [[FeelingStatus alloc] init];
//    feelingStatus3.code = @"UPSET-001";
//    feelingStatus3.feeling = @"Upset";
//    [self.dataArray addObject:feelingStatus3];
//    
//    FeelingStatus *feelingStatus4 = [[FeelingStatus alloc] init];
//    feelingStatus4.code = @"UPSET-002";
//    feelingStatus4.feeling = @"I wanna cry";
//    [self.dataArray addObject:feelingStatus4];
//    
//    FeelingStatus *feelingStatus5 = [[FeelingStatus alloc] init];
//    feelingStatus5.code = @"BORING-001";
//    feelingStatus5.feeling = @"Boring";
//    [self.dataArray addObject:feelingStatus5];
//}

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
        FeelingStatus *feelingStatus = [[FeelingStatus alloc]init];
        NSLog(@"code: %@", [item objectForKey:@"code"]);
        NSLog(@"feeling: %@", [item objectForKey:@"feeling"]);
        NSLog(@"lang: %@", [item objectForKey:@"lang"]);
        NSLog(@"category: %@", [item objectForKey:@"category"]);
        
        feelingStatus.code = [item objectForKey:@"code"];
        feelingStatus.feeling = [item objectForKey:@"feeling"];
        feelingStatus.category = [item objectForKey:@"category"];
        feelingStatus.lang = [item objectForKey:@"lang"];
        
        if ( [appLanguage isEqualToString:feelingStatus.lang] )
        {
            [self.dataArray addObject:feelingStatus];
        }
    }
    NSLog(@"%d objects loaded", [self.dataArray count]);
    [feelingStatusTbl reloadData];
    
    isDataLoaded = YES;
    
}

- (void) loadFeelStatusFromNetwork
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Loading", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"feelingstatus", @"cmd",
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

            NSLog(@"%@", @"loaded feeling status");
            // [self userDidJoin];
            // NSLog(@"Json: %@", JSON);
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
    static NSString *CellIdentifier = @"FeelingStatusCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    FeelingStatus *feelingStatus = (FeelingStatus*)[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = feelingStatus.feeling;
    
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

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [FeelingTableViewCell heightForCellWithFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected: %@", [self.dataArray objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeelingStatus *selectedFeelingStatus = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"Selected Feeling status: %@", [selectedFeelingStatus code]);
    
    // save the selection
    [[NSUserDefaults standardUserDefaults] setValue:selectedFeelingStatus.code forKey:@"SelectedFeelingStatusKey"];
    [[NSUserDefaults standardUserDefaults] setValue:selectedFeelingStatus.feeling forKey:@"SelectedFeelingStatusValue"];
    
    // and force the OS to save the changes to disk.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
