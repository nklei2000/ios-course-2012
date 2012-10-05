
#import "ComposeViewController.h"
#import "DataModel.h"
#import "Message.h"

@interface ComposeViewController ()
- (void)updateBytesRemaining:(NSString*)text;
@end

@implementation ComposeViewController

@synthesize delegate, dataModel, messageTextView, saveItem, navigationBar;

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self updateBytesRemaining:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[messageTextView becomeFirstResponder];
}

- (void)dealloc
{
	[messageTextView release];
	[saveItem release];
	[navigationBar release];
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

- (void)userDidCompose:(NSString*)text
{
	// Create a new Message object
	Message* message = [[Message alloc] init];
	message.senderName = nil;
	message.date = [NSDate date];
	message.text = text;

	// Add the Message to the data model's list of messages
	int index = [dataModel addMessage:message];

	// Add a row for the Message to ChatViewController's table view.
	// Of course, ComposeViewController doesn't really know that the
	// delegate is the ChatViewController.
	[self.delegate didSaveMessage:message atIndex:index];
	[message release];

	// Close the Compose screen
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveAction
{
	[self userDidCompose:self.messageTextView.text];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)updateBytesRemaining:(NSString*)text
{
	// Calculate how many bytes long the text is. We will send the text as
	// UTF-8 characters to the server. Most common UTF-8 characters can be
	// encoded as a single byte, but multiple bytes as possible as well.
	const char* s = [text UTF8String];
	size_t numberOfBytes = strlen(s);

	// Calculate how many bytes are left
	int remaining = MaxMessageLength - numberOfBytes;

	// Show the number of remaining bytes in the navigation bar's title
	if (remaining >= 0)
		self.navigationBar.topItem.title = [NSString stringWithFormat:NSLocalizedString(@"%d Remaining", nil), remaining];
	else
		self.navigationBar.topItem.title = NSLocalizedString(@"Text Too Long", nil);

	// Disable the Save button if no text is entered, or if it is too long
	self.saveItem.enabled = (remaining >= 0) && (text.length != 0);
}

- (BOOL)textView:(UITextView*)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
	NSString* newText = [theTextView.text stringByReplacingCharactersInRange:range withString:text];
	[self updateBytesRemaining:newText];
	return YES;
}

@end
