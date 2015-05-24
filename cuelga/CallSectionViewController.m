//
//  SecondViewController.m
//  cuelga
//
//  Created by Jorge Villa on 1/22/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "NSString+PNGValidation.h"
#import "PNGPhoneNumberFormatter.h"
#import "CallSectionViewController.h"
#import "Contact.h"
#import "CallManager.h"
#import "AppDelegate.h"
#import "EAIntroView.h"

@interface CallSectionViewController ()

@property (weak, nonatomic) IBOutlet GADBannerView *bottomBanner;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;


@end

@implementation CallSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Call.title", @"");
    
    self.phoneTextField.placeholder = NSLocalizedString(@"Call.phoneNumber", @"");
    [self customizeBottomBanner];
}


- (void)customizeBottomBanner {
    self.bottomBanner.adUnitID = @"ca-app-pub-5770021040900540/7336996912";
    self.bottomBanner.rootViewController = self;
    [self.bottomBanner loadRequest:[GADRequest request]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customizeCallButton];
    [self customizeMinuteLabel];
    [self showKeyboard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)showKeyboard {
    NSArray *viewsOnTop = [UIApplication sharedApplication].delegate.window.subviews;
    
    BOOL isTutorialOnTop = NO;;
    
    for (UIView *subview in viewsOnTop) {
        if(subview.tag == 121) {
            isTutorialOnTop = YES;
        }
    }
    
    if (!isTutorialOnTop) {
        [self.phoneTextField becomeFirstResponder];
    }
}

- (void)customizeMinuteLabel {
    self.minuteLabel.text = [NSString stringWithFormat:@"%li", (long)(CUELGAStoreMinutes)];
}

- (void)customizeCallButton {
    if (self.phoneTextField.text.length > 0) {
        self.callButton.enabled = YES;
    } else {
        self.callButton.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showKeyboard" object:nil];
}

- (void)keyboardWillToggle:(NSNotification *)aNotification {
    CGRect frame = [[[self tabBarController] tabBar] frame];
    CGRect keyboard = [[aNotification.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    frame.origin.y = keyboard.origin.y - frame.size.height;
    [UIView animateWithDuration:[[aNotification.userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue] animations:^
     {
         [[[self tabBarController] tabBar] setFrame:frame];
     }];
}

#pragma textField

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.phoneTextField) {
       
        if (string.length != 0) {
     
            NSFormatter * formatter = [[PNGPhoneNumberFormatter alloc] init];
            self.phoneTextField.text = [formatter stringForObjectValue:self.phoneTextField.text];
            self.callButton.enabled = YES;
        
        } else {
            self.callButton.enabled = NO;
        }
    }
    return YES;
}

#pragma PhoneCall

- (IBAction)didTapCall:(id)sender {
    
    if ([NSString validatePhoneNumber:self.phoneTextField.text]) {
        
        if (!CUELGAStoreFirstTime) {
            [self firstTimeCallAlert:self.phoneTextField.text];
            [DNPStoreSettings setBool:YES forKey:@"storePreviousLaunch"];
        } else {
            [self callWithPhoneNumber:self.phoneTextField.text];
        }
    }
}
- (void)firstTimeCallAlert:(NSString *)phoneNumber {
    
    NSMutableArray *alertActions = [NSMutableArray new];
    
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self callWithPhoneNumber:phoneNumber];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alertActions addObject:call];
    [alertActions addObject:cancelAction];
    
    ALERT_WITH_ACTIONS(@"Make Phone Call", @"Remember By default you will be alert in 5 minutes \n however you can go to settings and choose your alert time.", self, alertActions, UIAlertControllerStyleAlert);
}


- (void)callWithPhoneNumber:(NSString *)phoneNumber {
    
    Contact *contactModel = [Contact new];
    contactModel.phoneNumber = phoneNumber;
    
    NSURL *phoneUrl = [[CallManager sharedInstance] formatPhoneNumber:contactModel];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setCallNotification];
    }
}


- (void)noValidNumberAlert {
    
    NSMutableArray *alertActions = [NSMutableArray new];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alertActions addObject:cancelAction];
    
    ALERT_WITH_ACTIONS(@"!", @"You need to type a valid phone number.", self, alertActions, UIAlertControllerStyleAlert);
}



@end
