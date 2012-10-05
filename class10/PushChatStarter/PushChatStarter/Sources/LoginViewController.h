
@class DataModel;

// The Login screen lets the user register a nickname and chat room
@interface LoginViewController : UIViewController
{
}

@property (nonatomic, retain) IBOutlet UITextField* nicknameTextField;
@property (nonatomic, retain) IBOutlet UITextField* secretCodeTextField;

@property (nonatomic, assign) DataModel* dataModel;

- (IBAction)loginAction;

@end
