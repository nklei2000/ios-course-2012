
@class ComposeViewController;
@class DataModel;
@class Message;

// The delegate protocol for the Compose screen
@protocol ComposeDelegate <NSObject>
- (void)didSaveMessage:(Message*)message atIndex:(int)index;
@end

// The Compose screen lets the user write a new message
@interface ComposeViewController : UIViewController <UITextViewDelegate>
{
}

@property (nonatomic, retain) IBOutlet UITextView* messageTextView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* saveItem;
@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;

@property (nonatomic, assign) id<ComposeDelegate> delegate;
@property (nonatomic, assign) DataModel* dataModel;

- (IBAction)cancelAction;
- (IBAction)saveAction;

@end
