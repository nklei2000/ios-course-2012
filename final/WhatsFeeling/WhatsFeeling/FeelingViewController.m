//
//  FeelingViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "FeelingViewController.h"
#import "FeelingTableViewCell.h"
#import "ShowFeelingViewController.h"

#import "DataModel.h"
#import "Feeling.h"

#define CellFeelingTag  1000
#define CellImageTag    1001
#define CellLabelTag    1002

@interface FeelingViewController ()

@end

@implementation FeelingViewController
@synthesize feelingTbl;
@synthesize toolbar;


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
	 The conversation
	 */
    if ( [self.dataModel.feelings count] <= 0 )
    {
        Feeling *feeling1 = [[Feeling alloc] init];
        feeling1.text = @"Working Late.";
        feeling1.senderName = @"SamLei";
        
        Feeling *feeling2 = [[Feeling alloc] init];
        feeling2.text = @"Oh, too bad, don't work too much after work hour?";
        Feeling *feeling3 = [[Feeling alloc] init];
        feeling3.text = @"Yes, but this is a real trouble job.";
        feeling1.senderName = @"SamLei";
        
        [self.dataModel addFeeling:feeling1];
        [self.dataModel addFeeling:feeling2];
        [self.dataModel addFeeling:feeling3];
    }
    
	/*
	 Set the background color
	 */
	feelingTbl.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
	
	/*
	 Create header with two buttons
	 */
	CGSize screenSize = [[UIScreen mainScreen] applicationFrame].size;
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 55)];
	
	UIButton *newGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[newGroupButton addTarget:self action:@selector(addNewGroup) forControlEvents:UIControlEventTouchUpInside];
	newGroupButton.frame = CGRectMake(10, 5, 100, 30);
	[newGroupButton setTitle:NSLocalizedString(@"New Group",nil) forState:UIControlStateNormal];
    [[newGroupButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
	
	UIButton *loadEarlierButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[loadEarlierButton addTarget:self action:@selector(loadEarlierFeelings) forControlEvents:UIControlEventTouchUpInside];
	loadEarlierButton.frame = CGRectMake((screenSize.width / 3)+20, 5, 100, 30);
	[loadEarlierButton setTitle:NSLocalizedString(@"Load Earlier",nil) forState:UIControlStateNormal];
    [[loadEarlierButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    // loadEarlierButton.backgroundColor = [UIColor redColor];
    
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[infoButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	infoButton.frame = CGRectMake((screenSize.width) - 70, 5, 60, 30);
	[infoButton setTitle:NSLocalizedString(@"Info", nil) forState:UIControlStateNormal];
	[[infoButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    
	[headerView addSubview:newGroupButton];
	[headerView addSubview:loadEarlierButton];
	[headerView addSubview:infoButton];
	
	feelingTbl.tableHeaderView = headerView;
    
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setFeelingTbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     selector:@selector(keyboardWillShow:)
//	name:UIKeyboardWillShowNotification object:self.view.window];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addNewGroup {
    NSLog( @"Added new group!" );
}

- (void) loadEarlierFeelings {
    NSLog(@"Load Earlier Feelings");
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModel.feelings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    
    FeelingTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[FeelingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;        
    }
    
    [cell setFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
    
    //    UIImageView *balloonView = (UIImageView *)[[cell.contentView
    //            viewWithTag:CellFeelingTag]    viewWithTag:CellImageTag];
    //    UILabel *label = (UILabel *)[[cell.contentView viewWithTag:CellFeelingTag]
    //            viewWithTag:CellLabelTag];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeelingTableViewCell heightForCellWithFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)showFeelingToFriend:(id)sender
{
    // Popup show feeling screen
    ShowFeelingViewController *showFeelingViewController =
            [[ShowFeelingViewController alloc] initWithNibName:@"ShowFeelingViewController"
                                                        bundle:nil];
    // showFeelingViewController.dataModel = self.dataModel;
    
    [self.parentViewController presentModalViewController:showFeelingViewController animated:NO];
    
}
@end
