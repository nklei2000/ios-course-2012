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

#import "FeelingStatus.h"

#import "MyCommon.h"

@interface ShowFeelingViewController ()
- (void)showFeelingRequest;
- (void)userDidShow:(NSString*)text;
@end

@implementation ShowFeelingViewController
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
    
}

- (void)viewDidUnload
{
    [self setFeelingStatusTbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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




- (void)userDidShow:(NSString*)text
{
    NSLog(@"User did show.");
    
}

- (void)showFeelingRequest
{
	// [messageTextView resignFirstResponder];
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Sending", nil);
    
	//NSString* text = self.messageTextView.text;
    
    NSString *text = @"Hello Sam Lei";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"message", @"cmd",
                            [self.dataModel udid], @"udid",
                            text, @"text",
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
             [self userDidShow:text];
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
        

    }
    else if (indexPath.row == 1)
    {
        // cell.textLabel.text = @"Cell 2";
        NSString *selectedFeelingStatusKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFeelingStatusKey"];
        NSString *selectedFeelingStatusValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFeelingStatusValue"];
        
        NSLog(@"feeling[code:%@, felling:%@]", selectedFeelingStatusKey, selectedFeelingStatusValue);
              
        cell.textLabel.text = selectedFeelingStatusValue;
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
        // Contsruct another view controller here.
        FeelingStatusViewController *viewController = [[FeelingStatusViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


//- (void)ShowErrorAlert:(NSString*)text
//{
//	UIAlertView* alertView = [[UIAlertView alloc]
//                              initWithTitle:text
//                              message:nil
//                              delegate:nil
//                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
//                              otherButtonTitles:nil];
//    
//	[alertView show];
//}

- (IBAction)dismissMe:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

@end
