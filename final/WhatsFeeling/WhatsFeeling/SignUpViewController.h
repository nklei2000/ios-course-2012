//
//  SingUpViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

- (IBAction)tappedDone:(id)sender;

- (IBAction)tappedCancel:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
