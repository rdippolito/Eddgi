//
//  GameViewController.m
//  Eddgi
//
//  Created by Robert D'Ippolito on 2016-03-23.
//  Copyright (c) 2016 Robert D'Ippolito. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Firebase/Firebase.h>

@interface GameViewController()

@property (weak, nonatomic) IBOutlet UIView *highScoreView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *upgradeChar;

@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@end


@implementation GameViewController

- (void)viewDidLoad {
    
    // hide the views as default
    self.highScoreView.alpha = 0;
    self.loginView.alpha = 0;
    self.upgradeChar.alpha = 0;
    [super viewDidLoad];
    
    NSUserDefaults *loginCheck = [NSUserDefaults standardUserDefaults];
    NSString *userID = [loginCheck valueForKey:@"UserID"];
    
    if (userID != nil) {
        self.LoginButton.alpha = 0.5;
    } else {
        self.LoginButton.alpha = 1;
    }
    
}

// Bring up UIView that contains a UITableview that pulls the users name and highscore from the Firebase DB. The user should be able to scroll and find their score.
- (IBAction)highScoreTapped:(UIButton *)sender {
    
    // fade in the UIView when the HS button is tapped (TEMP)
    if(self.highScoreView.alpha == 0){
        [UIView animateWithDuration:(0.5) animations:^{
            self.highScoreView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:(0.5) animations:^{
            self.highScoreView.alpha = 0;
        }];
    }
}

// Brings up a login control that allows the user to login. The user will be defaulted as logged in if they login once. The user will also have the option to sign up through us or login using FB. The Sign up through us would require username + password x2.
- (IBAction)signUpTapped:(UIButton *)sender {
    
    // fade in the UIView when the HS button is tapped (TEMP)
    if(self.loginView.alpha == 0){
        [UIView animateWithDuration:(0.5) animations:^{
            self.loginView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:(0.5) animations:^{
            self.loginView.alpha = 0;
        }];
    }
}

// Brings up a UICollectionview with all of the available characters. Users should be able to scroll through the list and understand the required scores for each char.
- (IBAction)upgradeCharTapped:(UIButton *)sender {
    
    // fade in the UIView when the HS button is tapped (TEMP)
    if(self.upgradeChar.alpha == 0){
        [UIView animateWithDuration:(0.5) animations:^{
            self.upgradeChar.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:(0.5) animations:^{
            self.upgradeChar.alpha = 0;
        }];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
