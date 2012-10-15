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
#import "TouchFeelingViewController.h"

#import "DataModel.h"
#import "Feeling.h"

#import "MyCommon.h"

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
		
	UIButton *loadEarlierButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[loadEarlierButton addTarget:self action:@selector(loadEarlierFeelings) forControlEvents:UIControlEventTouchUpInside];
	// loadEarlierButton.frame = CGRectMake((screenSize.width / 3)+20, 5, 100, 30);
    loadEarlierButton.frame = CGRectMake(10, 5, 120, 30);
	[loadEarlierButton setTitle:NSLocalizedString(@"Load Earlier",nil) forState:UIControlStateNormal];
    [[loadEarlierButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    // loadEarlierButton.backgroundColor = [UIColor redColor];
    
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[infoButton addTarget:self action:@selector(infoFeeling) forControlEvents:UIControlEventTouchUpInside];
	infoButton.frame = CGRectMake((screenSize.width) - 110, 5, 100, 30);
	[infoButton setTitle:NSLocalizedString(@"Info", nil) forState:UIControlStateNormal];
	[[infoButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    
	UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[refreshButton addTarget:self action:@selector(refreshFeeling) forControlEvents:UIControlEventTouchUpInside];
	refreshButton.frame = CGRectMake((screenSize.width) - 110, 5, 100, 30);
	[refreshButton setTitle:NSLocalizedString(@"Refresh", nil) forState:UIControlStateNormal];
	[[refreshButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
    
	[headerView addSubview:loadEarlierButton];
    [headerView addSubview:refreshButton];
	//[headerView addSubview:infoButton];
	
	feelingTbl.tableHeaderView = headerView;
    
    // Localized the lables and buttons
    [MyCommon replaceTextWithLocalizedTextInSubviewsForView:self.view];
    
    
    if ( _refreshHeaderView == nil )
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - feelingTbl.bounds.size.height, self.view.frame.size.width, feelingTbl.bounds.size.height)];
        view.delegate = self;
        
        [feelingTbl addSubview:view];
        _refreshHeaderView = view;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setFeelingTbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    _refreshHeaderView = nil;
    
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

- (void) loadEarlierFeelings {
    NSLog(@"Load Earlier Feelings");
    [MyCommon ShowInfoAlert:@"Implement later"];
}

- (void) infoFeeling {
    NSLog(@"Info feeling");
    [MyCommon ShowInfoAlert:@"Implement later"];
}

- (void) refreshFeeling {
    NSLog(@"Refreshing feeling");
    [self.dataModel loadFeelings];
    
    [feelingTbl reloadData];
    
}

- (IBAction)showFeelingToFriend:(id)sender
{
    // Popup show feeling screen
    ShowFeelingViewController *showFeelingViewController =
    [[ShowFeelingViewController alloc] initWithNibName:@"ShowFeelingViewController"
                                                bundle:nil];
    showFeelingViewController.dataModel = self.dataModel;
    showFeelingViewController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:showFeelingViewController];
    
    [self.parentViewController presentModalViewController:navController animated:NO];
    
}

- (IBAction)giveTouchToFriend:(id)sender {

    // Popup show feeling screen
    TouchFeelingViewController *touchFeelingViewController =
    [[TouchFeelingViewController alloc] initWithNibName:@"TouchFeelingViewController"
                                                bundle:nil];
    touchFeelingViewController.dataModel = self.dataModel;
    touchFeelingViewController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:touchFeelingViewController];
    
    [self.parentViewController presentModalViewController:navController animated:NO];
    
}

- (void)scrollToNewestFeeling
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataModel.feelings.count-1) inSection:0];
    
    [self.feelingTbl scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark Customs
- (void)didShowFeeling:(Feeling*)feeling atIndex:(int)index;
{
    NSLog(@"delegate: didShowFeeling: %d", index);
    [self.dataModel loadFeelings];
    [feelingTbl reloadData];
    
    [self scrollToNewestFeeling];
    
}

- (void)didTouchFeeling:(Feeling*)feeling atIndex:(int)index;
{
    NSLog(@"delegate didTouchFeeling: %d", index);
    [self.dataModel loadFeelings];
    [feelingTbl reloadData];
    
    [self scrollToNewestFeeling];
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


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.feelingTbl];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



@end
