
#import "DataModel.h"
#import "Feeling.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const NicknameKey = @"Nickname";
static NSString* const SecretCodeKey = @"SecretCode";

static NSString* const UsernameKey = @"Username";
static NSString* const FirstNameKey = @"FirstName";
static NSString* const LastNameKey = @"LastName";
static NSString* const EmailKey = @"Email";
static NSString* const GenderKey = @"Gender";

static NSString* const SelectedContactGroupKey = @"SelectedContactGroup";

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
             @"", UsernameKey,
             @"", FirstNameKey,
             @"", LastNameKey,
             @"", EmailKey,
             @"", GenderKey,
             @"", SelectedContactGroupKey,
				nil]];
	}
}

// Returns the path to the <GROUP>-Feelings.plist file in the app's Documents directory
- (NSString*)feelingsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	
    NSString* fileName = [NSString stringWithFormat:@"%@-Feelings.plist", self.selectedContactGroup];
    NSLog( @"feelingsPath->File name: %@", fileName );
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


- (NSString*)feelingsPathOf:(NSString *)group
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	
    NSString* fileName = [NSString stringWithFormat:@"%@-Feelings.plist", group];
    NSLog( @"feelingsPathOf->File name: %@", fileName );
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)loadFeelings
{
	NSString* path = [self feelingsPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		// We store the feelings in a plist file inside the app's Documents
		// directory. The Feeling object conforms to the NSCoding protocol,
		// which means that it can "freeze" itself into a data structure that
		// can be saved into a plist file. So can the NSMutableArray that holds
		// these Message objects. When we load the plist back in, the array and
		// its Feelings "unfreeze" and are restored to their old state.

        NSString *decodeObjectKey = [NSString stringWithFormat:@"%@-Feelings", self.selectedContactGroup];
        NSLog(@"loadFeelings->decodeObjectKey: %@", decodeObjectKey);
        
		NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        if ( data != nil && [data length] > 0 )
        {
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            // self.feelings = [unarchiver decodeObjectForKey:@"Feelings"];
            self.feelings = [unarchiver decodeObjectForKey:decodeObjectKey];
            [unarchiver finishDecoding];
        }
        else
        {
            self.feelings = [NSMutableArray arrayWithCapacity:20];
            // self.feelings = [[NSMutableArray alloc] initWithCapacity:20];
        }
	}
	else
	{
		self.feelings = [NSMutableArray arrayWithCapacity:20];
        // self.feelings = [[NSMutableArray alloc] initWithCapacity:20];
	}
}

- (void)saveFeelings
{
    NSString *encodeObjectKey = [NSString stringWithFormat:@"%@-Feelings", self.selectedContactGroup];
    
    NSLog(@"saveFeelings->decodeObjectKey: %@", encodeObjectKey);
    
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // [archiver encodeObject:self.feelings forKey:@"Feelings"];
    [archiver encodeObject:self.feelings forKey:encodeObjectKey];
    
	[archiver finishEncoding];
	[data writeToFile:[self feelingsPath] atomically:YES];
    
    NSLog( @"Save data to: %@", [self feelingsPath] );
    
}

- (Feeling *)loadNewestFeelingOf:(NSString *)group
{
    NSLog( @"loadNewestFeelingOf: %@", group );
    
    NSMutableArray *savedFeelings = [[NSMutableArray alloc] initWithCapacity:20];
    
	NSString* path = [self feelingsPathOf:group];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{        
        NSString *decodeObjectKey = [NSString stringWithFormat:@"%@-Feelings", group];
        
		NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        if ( data != nil && [data length] > 0 )
        {
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            savedFeelings = [unarchiver decodeObjectForKey:decodeObjectKey];
            [unarchiver finishDecoding];
        }
	}

    if ( savedFeelings != nil && [savedFeelings count])
    {
        NSLog( @"savedFeelings count: %d", [savedFeelings count]);
        return [savedFeelings objectAtIndex:[savedFeelings count]-1];
    }
    
    NSLog( @"savedFeelings nothing loaded" );

    return nil;
    
}


// Returns the path to the <GROUP>-ContactGroups.plist file in the app's Documents directory
- (NSString*)contactGroupsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"ContactGroups.plist"];
    
}

- (void)loadContactGroups
{
	NSString* path = [self contactGroupsPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{                
		NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        if ( data != nil && [data length] > 0 )
        {
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.contactGroups = [unarchiver decodeObjectForKey:@"ContactGroups"];
            [unarchiver finishDecoding];
        }
        else
        {
            self.contactGroups = [NSMutableArray arrayWithCapacity:20];
        }
	}
	else
	{
		self.contactGroups = [NSMutableArray arrayWithCapacity:20];
	}
}

- (void)saveContactGroups
{    
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
    [archiver encodeObject:self.contactGroups forKey:@"ContactGroups"];
    
	[archiver finishEncoding];
	[data writeToFile:[self contactGroupsPath] atomically:YES];
    
    NSLog( @"Save data to: %@", [self contactGroupsPath] );
    
}

- (void)clearGroupHistory
{
    //	NSMutableData* data = [[NSMutableData alloc] init];
    //	[data writeToFile:[self feelingsPath] atomically:YES];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileDeleted = [fileManager removeItemAtPath:[self feelingsPath] error:&error];
    if (fileDeleted != YES || error != nil)
    {
        // Deal with the error...
        NSLog(@"Error: %@", [error description]);
        return;
    }
    
    NSString *encodeObjectKey = [NSString stringWithFormat:@"%@-Feelings", self.selectedContactGroup];   
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // [archiver encodeObject:self.feelings forKey:@"Feelings"];
    [archiver encodeObject:self.feelings forKey:encodeObjectKey];
    [archiver finishEncoding];
    
}

- (void)clearAllHistory
{
    NSLog(@"Clearing all feeling history");
    
    // Path to the Documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0)
    {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Print out the path to verify we are in the right place
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"Documents Directory: %@", documentsDirectory);
        
        // For each file in the directory, create full path and delete the file
        for (NSString *file in [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error])
        {
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:file];
            NSLog(@"File : %@", filePath);

            NSString *fileName = [filePath lastPathComponent];
            
            NSRange range = [fileName rangeOfString:@"Feelings.plist"];
            if ( range.length <= 0 )
            {
                NSLog(@"File %@ is not the Feelings stored file, skipped!", fileName);
                continue;
            }
            
            NSLog(@"Feelings stored file found: %@", fileName);
            
            // BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
            BOOL fileDeleted = NO;
            
            if (fileDeleted != YES || error != nil)
            {
                // Deal with the error...
                NSLog(@"Error: %@", [error description]);
                continue;
            }
            
            NSMutableArray* parts = [NSMutableArray arrayWithArray:[fileName componentsSeparatedByString:@"-"]];
            
            if ( parts != nil && [parts count] )
            {
                NSString *groupId = [parts objectAtIndex:0];
                NSLog(@"Group (file name): %@", groupId);
                
                if ( groupId != nil && groupId.length > 0)
                {
                    NSString *encodeObjectKey = [NSString stringWithFormat:@"%@-Feelings", groupId];
                    
                    NSLog(@"encodeObjectKey: %@", encodeObjectKey);
                    
                    NSMutableData* data = [[NSMutableData alloc] init];
                    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                    [archiver encodeObject:self.feelings forKey:encodeObjectKey];
                    [archiver finishEncoding];
                }
            }
        }
    }
}

- (int)addFeeling:(Feeling*)feeling
{
    
//    NSLog(@"feeling: %@", feeling.type);
	[self.feelings addObject:feeling];
//    NSLog(@"count: %d", [self.feelings count]);
    
	[self saveFeelings];
	return self.feelings.count - 1;
}


- (int)addContactGroup:(ContactGroup*)contactGroup
{
	[self.contactGroups addObject:contactGroup];
	[self saveContactGroups];
	return self.contactGroups.count - 1;
}




- (void)syncUserDefaults {
    [[NSUserDefaults standardUserDefaults] synchronize];
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


- (NSString*)username
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
}

- (void)setUsername:(NSString*)username
{
	[[NSUserDefaults standardUserDefaults] setObject:username forKey:UsernameKey];
}


- (NSString*)firstName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:FirstNameKey];
}

- (void)setFirstName:(NSString*)firstName
{
	[[NSUserDefaults standardUserDefaults] setObject:firstName forKey:FirstNameKey];
}

- (NSString*)lastName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:LastNameKey];
}

- (void)setLastName:(NSString*)lastName
{
	[[NSUserDefaults standardUserDefaults] setObject:lastName forKey:LastNameKey];
}

- (NSString*)email
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:EmailKey];
}

- (void)setEmail:(NSString*)email
{
	[[NSUserDefaults standardUserDefaults] setObject:email forKey:EmailKey];
}

- (NSString*)gender
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:GenderKey];
}

- (void)setGender:(NSString*)gender
{
	[[NSUserDefaults standardUserDefaults] setObject:gender forKey:GenderKey];
}

- (NSString *)selectedContactGroup
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:SelectedContactGroupKey];
}

- (void)setSelectedContactGroup:(NSString *)selectedContactGroup
{
	[[NSUserDefaults standardUserDefaults] setObject:selectedContactGroup forKey:SelectedContactGroupKey];
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
