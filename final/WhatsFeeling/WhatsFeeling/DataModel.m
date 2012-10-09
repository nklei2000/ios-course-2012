
#import "DataModel.h"
#import "Feeling.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const NicknameKey = @"Nickname";
static NSString* const SecretCodeKey = @"SecretCode";
static NSString* const JoinedKey = @"JoinedFeeling";
static NSString* const DeviceTokenKey = @"DeviceToken";
static NSString* const UDIDKey = @"UDID";

@implementation DataModel

@synthesize feelings;

+ (void)initialize
{
	if (self == [DataModel class])
	{
		// Register default values for our settings
		[[NSUserDefaults standardUserDefaults] registerDefaults:
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"", NicknameKey,
				@"", SecretCodeKey,
				[NSNumber numberWithInt:0], JoinedKey,
             @"0", DeviceTokenKey,
             @"", UDIDKey,
				nil]];
	}
}

// Returns the path to the Feelings.plist file in the app's Documents directory
- (NSString*)feelingsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"Feelings.plist"];
}

- (void)loadFeelings
{
	NSString* path = [self feelingsPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		// We store the messages in a plist file inside the app's Documents
		// directory. The Message object conforms to the NSCoding protocol,
		// which means that it can "freeze" itself into a data structure that
		// can be saved into a plist file. So can the NSMutableArray that holds
		// these Message objects. When we load the plist back in, the array and
		// its Messages "unfreeze" and are restored to their old state.

		NSData* data = [[NSData alloc] initWithContentsOfFile:path];
		NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		self.feelings = [unarchiver decodeObjectForKey:@"Feelings"];
		[unarchiver finishDecoding];

	}
	else
	{
		self.feelings = [NSMutableArray arrayWithCapacity:20];
	}
}

- (void)saveFeelings
{
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self.feelings forKey:@"Feelings"];
	[archiver finishEncoding];
	[data writeToFile:[self feelingsPath] atomically:YES];
}

- (void)clearFeelings
{
//	NSMutableData* data = [[NSMutableData alloc] init];
//	[data writeToFile:[self feelingsPath] atomically:YES];
}


- (int)addFeeling:(Feeling*)feeling
{
	[self.feelings addObject:feeling];
	[self saveFeelings];
	return self.feelings.count - 1;
}

- (NSString*)nickname
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:NicknameKey];
}

- (void)setNickname:(NSString*)name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:NicknameKey];
}

- (NSString*)secretCode
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:SecretCodeKey];
}

- (void)setSecretCode:(NSString*)string
{
	[[NSUserDefaults standardUserDefaults] setObject:string forKey:SecretCodeKey];
}

- (BOOL)joined
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:JoinedKey];
}

- (void)setJoined:(BOOL)value
{
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:JoinedKey];
}

- (NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

- (void)setDeviceToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}

- (NSString*)udid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:UDIDKey];
}

- (void)setUdid:(NSString*)string
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:UDIDKey];
}

@end
