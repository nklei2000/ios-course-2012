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

@interface FeelingStatusViewController ()

@end

@implementation FeelingStatusViewController

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
    
    [self loadFeelingStatuses];
    
     self.navigationItem.title = NSLocalizedString(@"Choose your feeling", nil);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // we need to call this every time when the view shows.
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadFeelingStatuses
{
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    FeelingStatus *feelingStatus1 = [[FeelingStatus alloc] init];
    feelingStatus1.code = @"HAPPY-001";
    feelingStatus1.value = @"Happy";
    [self.dataArray addObject:feelingStatus1];
    
    FeelingStatus *feelingStatus2 = [[FeelingStatus alloc] init];
    feelingStatus2.code = @"HAPPY-002";
    feelingStatus2.value = @"Happy very much";
    [self.dataArray addObject:feelingStatus2];
    
    FeelingStatus *feelingStatus3 = [[FeelingStatus alloc] init];
    feelingStatus3.code = @"UPSET-001";
    feelingStatus3.value = @"Upset";
    [self.dataArray addObject:feelingStatus3];
    
    FeelingStatus *feelingStatus4 = [[FeelingStatus alloc] init];
    feelingStatus4.code = @"UPSET-002";
    feelingStatus4.value = @"I wanna cry";
    [self.dataArray addObject:feelingStatus4];
    
    FeelingStatus *feelingStatus5 = [[FeelingStatus alloc] init];
    feelingStatus5.code = @"BORING-001";
    feelingStatus5.value = @"Boring";
    [self.dataArray addObject:feelingStatus5];
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
    cell.textLabel.text = feelingStatus.value;
    
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
    
    NSString *selectedFeelingStatus = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"Selected Feeling status: %@", selectedFeelingStatus);
    
    // save the selection
    [[NSUserDefaults standardUserDefaults] setValue:selectedFeelingStatus forKey:@"SelectedFeelingStatus"];
    
    // and force the OS to save the changes to disk.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
