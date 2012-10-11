//
//  ShowFeelingViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "ShowFeelingViewController.h"
#import "FeelingStatusViewController.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "DataModel.h"

#import "Feeling.h"
#import "FeelingStatus.h"

#import "MyCommon.h"

@interface ShowFeelingViewController ()
- (void)showFeelingRequest:(Feeling*)feeling;
- (void)feelingDidSend;
- (void)sendFeeling;
@end

@implementation ShowFeelingViewController
@synthesize reasonTextField;
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
    
    // save the selection
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusKey"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.reasonTextField.text = @"";
    
    // Contsruct another view controller here.
    self.feelingStatusViewController = [[FeelingStatusViewController alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendFeeling)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSendFeeling)];
}


- (void)viewDidUnload
{
    [self setFeelingStatusTbl:nil];
    [self setReasonTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.feelingStatusViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     selector:@selector(keyboardWillShow:)
//	name:UIKeyboardWillShowNotification object:self.view.window];
    
    NSLog(@"view will appear.");
    
    [feelingStatusTbl reloadData];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)feelingDidSend
{
    NSLog(@"User did show.");
 
    [reasonTextField resignFirstResponder];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancelSendFeeling
{
    NSLog(@"Cancelled send feeling...");
        
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusKey"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.reasonTextField.text = @"";
    
    [reasonTextField resignFirstResponder];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)sendFeeling
{
    NSLog(@"Sending feeling to your friends...");
    
    Feeling *feeling = [[Feeling alloc] init];
    
    feeling.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFeelingStatusValue"];
    feeling.reason = reasonTextField.text;
    
    if ( feeling.text.length == 0 )
    {
        [MyCommon ShowErrorAlert:@"Please choose your feeling"];
        return;
    }
    
    [self showFeelingRequest:feeling];
    
}

- (void)showFeelingRequest:(Feeling *)feeling
{
    if ( feeling == nil || feeling.text.length == 0)
    {
        [MyCommon ShowErrorAlert:NSLocalizedString(@"NOTHING_SENT", nil)];
        return;
    }
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Sending", nil);
    
    // NSString *text = @"Hello Sam Lei";
    
    NSString *feelingAndReason = [NSString stringWithFormat:@"%@ %@", feeling.text, feeling.reason];
    
    NSLog(@"feeling and reason: %@, udid: %@", feelingAndReason, [self.dataModel udid]);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"showfeeling", @"cmd",
                            [self.dataModel udid], @"udid",
                            feelingAndReason, @"text",
                            nil];
    NSLog(@"%@", params);
    
    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"/api.php" parameters:params
                 success:^(AFHTTPRequestOperation *operation, id response)
     {
         NSString *text = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"Response: %@", text);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"%@", @"user did show");
             [self feelingDidSend];
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", [error localizedDescription]);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MyCommon ShowErrorAlert:[error localizedDescription]];
         }
     }];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [self.dataModel.feelings count];
    return 2;
    // return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowFeelingCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    // reset the detail text first.
    cell.detailTextLabel.text = @"";
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"What's your feeling now";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        cell.accessoryView = button;
    }
    else if (indexPath.row == 1)
    {
        // cell.textLabel.text = @"Cell 2";
        NSString *selectedFeelingStatusKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFeelingStatusKey"];
        NSString *selectedFeelingStatusValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFeelingStatusValue"];
        
        NSLog(@"feeling[code:%@, felling:%@]", selectedFeelingStatusKey, selectedFeelingStatusValue);
              
        cell.textLabel.text = selectedFeelingStatusValue;
        cell.textLabel.textColor = [UIColor blueColor];
    }
        
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [FeelingTableViewCell heightForCellWithFeeling:[self.dataModel.feelings objectAtIndex:indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // NSLog(@"Selected: %@", [self.dataArray objectAtIndex:indexPath.row]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.navigationController pushViewController:self.feelingStatusViewController animated:YES];
    }
    
}


@end
