
@class ChatViewController;
@class DataModel;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UIViewController* viewController;
@property (nonatomic, retain) IBOutlet ChatViewController* chatViewController;

@property (nonatomic, retain) DataModel* dataModel;

@end
