
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "DataModel.h"
#import "LoginViewController.h"
#import "Message.h"

void ShowErrorAlert(NSString* text)
{
	UIAlertView* alertView = [[UIAlertView alloc]
		initWithTitle:text
		message:nil
		delegate:nil
		cancelButtonTitle:NSLocalizedString(@"OK", nil)
		otherButtonTitles:nil];

	[alertView show];
	[alertView release];
}

@implementation AppDelegate

@synthesize window, viewController, chatViewController, dataModel;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	// Create the main data model object
	dataModel = [[DataModel alloc] init];
	[dataModel loadMessages];
	chatViewController.dataModel = dataModel;

	[self.window addSubview:self.viewController.view];
	[self.window makeKeyAndVisible];

	// Show the login screen if the user hasn't joined a chat yet
	if (![dataModel joinedChat])
	{
		LoginViewController* loginController = [[LoginViewController alloc] init];
		loginController.dataModel = dataModel;
		[self.viewController presentModalViewController:loginController animated:NO];
		[loginController release];
	}

	return YES;
}

- (void)dealloc
{
	[dataModel release];
	[window release];
	[viewController release];
	[chatViewController release];
	[super dealloc];
}

@end
