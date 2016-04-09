//
//  LoginSignupViewController.m
//  Eddgi
//
//  Created by Robert D'Ippolito on 2016-03-25.
//  Copyright © 2016 Robert D'Ippolito. All rights reserved.
//

#import "LoginSignupViewController.h"
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString * const kFirebaseURL = @"https://eddgi.firebaseIO.com";

@interface LoginSignupViewController ()

//login buttons + textfields
@property (weak, nonatomic) IBOutlet UILabel *displayText;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation LoginSignupViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *loginCheck = [NSUserDefaults standardUserDefaults];
    NSString *userID = [loginCheck valueForKey:@"UserID"];
    
    if (userID != nil) {
        NSLog(@"Someone is logged in: %@", userID);
        self.passwordConfirmTextField.alpha = 0;
        self.passwordTextField.alpha = 0;
        self.usernameTextField.alpha = 0;
        self.loginButton.alpha = 0;
        self.signupButton.alpha = 0;
        self.fbLoginButton.alpha = 0;
        self.displayText.text = @"You are already logged in";
    } else {
        NSLog(@"Nobody is logged in");
        self.logoutButton.alpha = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)updateCurrentUser:(FAuthData *)currentUser {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutButtonTapped:(id)sender {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"Cleared");
    
}


- (IBAction)loginButtonTapped:(UIButton *)sender {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:kFirebaseURL];
    [ref authUser:self.usernameTextField.text password: self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
    } else {
        NSLog(@"Login Successful");
        NSString *username = authData.providerData[@"email"];
        NSLog(@"Email: %@", username);
    }
}];
    
    
}

- (IBAction)signupButtonTapped:(UIButton *)sender {
    
    Firebase *ref = [[Firebase alloc] initWithUrl: kFirebaseURL];
    NSLog(@"This was tapped: %@, %@", self.passwordConfirmTextField.text, self.passwordTextField.text);
    
    if([self.passwordTextField.text isEqualToString:self.passwordTextField.text]){
        
        [ref createUser:self.usernameTextField.text password:self.passwordTextField.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
                // There was an error creating the account
                NSLog(@"error: %@", error);
            } else {
                NSString *uid = [result objectForKey:@"uid"];
                NSLog(@"Successfully created user account with uid: %@", uid);
                
                [ref authUser:self.usernameTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    if (error) {
                        // There was an error logging in to this account
                        NSLog(@"error: %@", error);
                    } else {
                        // We are now logged in
                        NSLog(@"We are logged in");
                        NSUserDefaults *userDetails = [NSUserDefaults standardUserDefaults];
                        [userDetails setValue:uid forKey:@"UserID"];
                    }
                }];
            }
        }];
    } else {
        NSLog(@"Passwords did not match");
    }
}

- (void(^)(NSError *, FAuthData *))loginBlockForProviderName:(NSString *)providerName
{
    // this callback block can be used for every login method
    return ^(NSError *error, FAuthData *authData) {
        if (error != nil) {
            // there was an error authenticating with Firebase
            NSLog(@"Error logging in to Firebase: %@", error);
            // display an alert showing the error message

        } else {
            // all is fine, set the current user and update UI
        }
    };
}

- (BOOL)facebookIsSetup {
    NSString *facebookAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
    NSString *facebookDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookDisplayName"];
    BOOL canOpenFacebook =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb%@://", facebookAppId]]];
    
    
    if ([@"965234716851875" isEqualToString:facebookAppId] ||
        [@"EDGGI" isEqualToString:facebookDisplayName]) {
        return YES;
    } else {
        NSLog(@"The result was yes");
        return YES;
    }
}
- (IBAction)facebookButtonTapped:(UIButton *)sender {
    
    if ([self facebookIsSetup]) {
        [self facebookLogin];
    }
    
}

- (void)facebookLogin {
    
    // Open a session showing the user the login UI
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    Firebase *ref = [[Firebase alloc] initWithUrl:kFirebaseURL];

    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Facebook login failed. Error: %@", error);
        } else if (result.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else if ([FBSDKAccessToken currentAccessToken]) {
            [ref authWithOAuthProvider:@"facebook" token:[[FBSDKAccessToken currentAccessToken] tokenString] withCompletionBlock:[self loginBlockForProviderName:@"Facebook"]];
        }
    }];
}

@end
