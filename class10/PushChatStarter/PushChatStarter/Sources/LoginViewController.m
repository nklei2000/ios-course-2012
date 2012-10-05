
#import "LoginViewController.h"
#import "DataModel.h"

@implementation LoginViewController

@synthesize dataModel, nicknameTextField, secretCodeTextField;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.nicknameTextField.text = [self.dataModel nickname];
	self.secretCodeTextField.text = [self.dataModel secretCode];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (nicknameTextField.text.length == 0)
		[nicknameTextField becomeFirstResponder];
	else
		[secretCodeTextField becomeFirstResponder];
}

- (void)dealloc
{
	[nicknameTextField release];
	[secretCodeTextField release];
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

- (void)userDidJoin
{
	// Close the Login screen
	[self.dataModel setJoinedChat:YES];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginAction
{
	if (self.nicknameTextField.text.length == 0)
	{
		ShowErrorAlert(NSLocalizedString(@"Fill in your nickname", nil));
		return;
	}

	if (self.secretCodeTextField.text.length == 0)
	{
		ShowErrorAlert(NSLocalizedString(@"Fill in a secret code", nil));
		return;
	}

	[self.dataModel setNickname:self.nicknameTextField.text];
	[self.dataModel setSecretCode:self.secretCodeTextField.text];

	// Hide the keyboard
	[self.nicknameTextField resignFirstResponder];
	[self.secretCodeTextField resignFirstResponder];

	[self userDidJoin];
}

@end
