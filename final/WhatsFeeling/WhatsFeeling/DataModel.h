
@class Feeling;

// The main data model object
@interface DataModel : NSObject
{
}

// The complete history of feelings this user has sent and received, in
// chronological order (oldest first).
@property (nonatomic, retain) NSMutableArray* feelings;

// Loads the list of feelings from a file.
- (void)loadFeelings;

// Saves the list of feelings to a file.
- (void)saveFeelings;

// Adds a feeling that the user show himself or that we received through
// a push notification. Returns the index of the new feeling in the list
// of feelings.
- (int)addFeeling:(Feeling *)feeling;

// Get and set the user's nickname.
- (NSString*)nickname;
- (void)setNickname:(NSString*)nickname;

- (NSString*)username;
- (void)setUsername:(NSString*)username;

// Get and set the secret code that the user is registered for.
- (NSString*)secretCode;
- (void)setSecretCode:(NSString*)string;

- (NSString*)firstName;
- (void)setFirstName:(NSString*)firstName;

- (NSString*)lastName;
- (void)setLastName:(NSString*)lastName;

- (NSString*)email;
- (void)setEmail:(NSString*)email;

- (NSString*)gender;
- (void)setGender:(NSString*)gender;

- (NSString*)selectedContactGroup;
- (void)setSelectedContactGroup:selectedContactGroup;

// Determines whether the user has successfully.
- (BOOL)joined;
- (void)setJoined:(BOOL)value;

- (NSString*)udid;
- (void)setUdid:(NSString*)string;

- (NSString*)deviceToken;
- (void)setDeviceToken:(NSString*)token;

- (void)syncUserDefaults;

- (void)clearGroupHistory;
- (void)clearAllHistory;

@end
