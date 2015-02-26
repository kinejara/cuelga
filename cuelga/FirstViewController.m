//
//  FirstViewController.m
//  cuelga
//
//  Created by Jorge Villa on 1/22/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import "FirstViewController.h"
#import "Contact.h"
#import "CallManager.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *storeContactNames;
@property (nonatomic, strong) NSMutableArray *storeContactPhones;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.storeContactNames = [NSMutableArray arrayWithArray:CUELGAStoreContacts];
    self.storeContactPhones = [NSMutableArray arrayWithArray:CUELGAStoreNumbers];
 
    [self customizeNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeNavigationBar {
    
    UIBarButtonItem *addContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddContact)];
    
    self.navigationItem.rightBarButtonItems = @[addContactButton];
}

- (void)didTapAddContact {
    [self getAddressBookPermission];
}

- (void)getAddressBookPermission {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self pickContactFromAddressBook];
            } else {
                // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self pickContactFromAddressBook];
    }
    else {
        // If the user user has NOT earlier provided the access, create an alert to tell the user to go to Settings app and allow access
    }
}

- (void)pickContactFromAddressBook {
    // The user has previously given access, add the contact
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {

    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
    UIImage  *contactImg = [UIImage imageWithData:imgData];
    
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
 
    NSString *fullName = @"";
    
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    if (contactImg == nil) {
        contactImg = [UIImage imageNamed:@"noContact"];
    }
    if ([self validatePhoneNumber:number]) {
        [self updateContactOnScreenWith:number withContactName:fullName];
    } else {
         //TODO: alert to pick another contact
        NSLog(@"invalid");
    }
}

// Implement this delegate method to make the Cancel button of the Address Book working.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateContactOnScreenWith:(NSString *)phoneNumber withContactName:(NSString *)contactName  {
    
    [self storeFavNumberWithContactName:contactName andPhone:phoneNumber];
}

- (BOOL)validatePhoneNumber:(NSString *)phone {
    
    if (![phone isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([phone isEqualToString:@""]) {
        return NO;
    }
    
    NSCharacterSet *invalidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" ()+0123456789 -"];
    
    return [[phone stringByTrimmingCharactersInSet:invalidCharacterSet] isEqualToString:@""];
}

- (void)storeFavNumberWithContactName:(NSString *)contactName andPhone:(NSString *)phone {

    if ([self.storeContactNames containsObject:@"Selecciona un contacto presionando '+' "]) {
        [self.storeContactNames removeObjectAtIndex:0];
        [self.storeContactPhones removeObjectAtIndex:0];
    }
    
    if (self.storeContactPhones.count >= 10) {
        [self.storeContactPhones removeObjectAtIndex:0];
        [self.storeContactNames removeObjectAtIndex:0];
    }
    
    if (![self.storeContactPhones containsObject:phone]) {
        
        [self.storeContactPhones addObject:phone];
        [self.storeContactNames addObject:contactName];
    }
    
    [DNPStoreSettings setValue:self.storeContactNames forKey:@"storeNames"];
    [DNPStoreSettings setValue:self.storeContactPhones forKey:@"storeNumbers"];
    
    [self.tableView reloadData];
}

#pragma mark Call

- (IBAction)prepareCallContactWithPhone:(NSString *)phoneNumber  {
    
    if (![phoneNumber isEqualToString:@""]) {
    
        if (!CUELGAStoreFirstTime) {
            [self firstTimeCallAlert:phoneNumber];
            [DNPStoreSettings setBool:YES forKey:@"storePreviousLaunch"];
        } else {
            [self callWithPhoneNumber:phoneNumber];
        }
    
    } else {
        [self noValidContactAlert];
    }
}

- (void)noValidContactAlert {
    
    NSMutableArray *alertActions = [NSMutableArray new];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alertActions addObject:cancelAction];
    
    ALERT_WITH_ACTIONS(@"!", @"You need to add a new contact\nPress over '+'\nAnd select a contact from your contact list.", self, alertActions, UIAlertControllerStyleAlert);
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //TODO: translate this
    return @"Contactos Frecuentes";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.storeContactNames.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     NSUInteger dataItemIndex = (self.storeContactNames.count - 1 - indexPath.row);

     UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
     
     if (cell == nil) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     }
     
     cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:22.0];
     
     cell.textLabel.text = self.storeContactNames[dataItemIndex];
     cell.detailTextLabel.text = self.storeContactPhones[dataItemIndex];
     
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger dataItemIndex = (self.storeContactNames.count - 1 - indexPath.row);
    
    [self prepareCallContactWithPhone:self.storeContactPhones[dataItemIndex]];
}

@end
