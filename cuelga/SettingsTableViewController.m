//
//  SettingsTableViewController.m
//  cuelga
//
//  Created by Jorge on 2/10/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *alertTimeField;
@property (weak, nonatomic) IBOutlet UITextField *soundField;
@property (weak, nonatomic) IBOutlet UITextView *tipsView;
@property (strong, nonatomic) UIPickerView *timePickerView;
@property (strong, nonatomic) UIPickerView *soundPickerView;
@property (strong, nonatomic) NSArray *minutes;
@property (strong, nonatomic) NSArray *sounds;


typedef NS_ENUM(NSInteger, tableSections) {
    callTimerSection = 0,
    notificationSoundSection,
    aboutSection
};

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.minutes = @[@1, @5, @10, @15];
    self.sounds = @[@"Default.aiff", @"Alarm.caf", @"Bloom.caf"];
    
    self.title = NSLocalizedString(@"Settings.title", @"");
    self.alertTimeField.text = [NSString stringWithString:[self formatTimeLabel:CUELGAStoreMinutes]];
    self.tipsView.text = NSLocalizedString(@"Settings.info", @"");
    self.alertTimeField.inputView = [self createTimePickerView];
    self.soundField.inputView = [self createSoundPickerView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self customizeSoundTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)customizeSoundTextField {
    NSString *storedIndex = CUELGAStoreSound;
    NSInteger index = [self.sounds indexOfObject:storedIndex];
    NSArray *soundNames = [self.sounds[index] componentsSeparatedByString:@"."];
    NSString *clearName = soundNames[0];
    
    self.soundField.text = clearName;
}

- (NSString *)formatTimeLabel:(NSInteger)storedNumber {
    NSString *minutoString = NSLocalizedString(@"Settings.minute", @"");
    NSMutableString *alertTextfieldText = [NSMutableString stringWithFormat:@"%ld %@",(long)storedNumber, minutoString];
    
    if (storedNumber != 1) {
        [alertTextfieldText appendString:@"s"];
    }
    
    return alertTextfieldText;
}

- (IBAction)didTapRateMe:(id)sender {
    NSString *iTunesLink = appstoreURL;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == callTimerSection) {
        //self.alertTimeField.inputView = [self createTimePickerView];
    }
}

#pragma mark TimePicker

- (void)didTapDoneFromSoundPicker {
    [self.view endEditing:YES];
    
    NSInteger selectedRow = [self.soundPickerView selectedRowInComponent:0];
    [DNPStoreSettings setObject:self.sounds[selectedRow] forKey:@"storeSound"];
}

- (void)didTapDoneFromPicker {
    [self.view endEditing:YES];
    
    NSInteger selectedRow = [self.timePickerView selectedRowInComponent:0];
    [DNPStoreSettings setObject:self.minutes[selectedRow] forKey:@"storeMinutes"];
}

- (UIView *)createSoundPickerView {
    CGFloat widht = self.view.frame.size.width;
    
    UIView *containerPickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, widht, 216.0f)];
    
    self.soundPickerView = [[UIPickerView alloc] init];
    self.soundPickerView.frame = CGRectMake(0.0f, 50.0f, widht, 162.0f);
    self.soundPickerView.delegate = self;
    self.soundPickerView.dataSource = self;
    self.soundPickerView.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, widht, 44.0f)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    //TODO: translate this
    UIBarButtonItem *barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDoneFromSoundPicker)];
    barButtonNext.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [[NSArray alloc] initWithObjects:flex, barButtonNext, nil];
    
    [containerPickerView addSubview:toolBar];
    [containerPickerView addSubview:self.soundPickerView];
    
    NSString *storedIndex = CUELGAStoreSound;
    [self.soundPickerView selectRow:[self.sounds indexOfObject:storedIndex] inComponent:0 animated:YES];
    
    return containerPickerView;
}

- (UIView *)createTimePickerView {
    CGFloat widht = self.view.frame.size.width;
    
    UIView *containerPickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, widht, 216.0f)];
    
    self.timePickerView = [[UIPickerView alloc] init];
    self.timePickerView.frame = CGRectMake(0.0f, 50.0f, widht, 162.0f);
    self.timePickerView.delegate = self;
    self.timePickerView.dataSource = self;
    self.timePickerView.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, widht, 44.0f)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    //TODO: translate this
    UIBarButtonItem *barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDoneFromPicker)];
    barButtonNext.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [[NSArray alloc] initWithObjects:flex, barButtonNext, nil];
    
    [containerPickerView addSubview:toolBar];
    [containerPickerView addSubview:self.timePickerView];
    
    NSInteger storedIndex = CUELGAStoreMinutes;
    [self.timePickerView selectRow:[self.minutes indexOfObject:[NSNumber numberWithInt:storedIndex]] inComponent:0 animated:YES];
    
    return containerPickerView;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.soundPickerView) {
        return self.sounds.count;
    } else if (pickerView == self.timePickerView) {
        return self.minutes.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.soundPickerView) {
        NSArray *soundNames = [self.sounds[row] componentsSeparatedByString:@"."];
        return [NSString stringWithFormat:@"%@",soundNames[0]];
    } else if (pickerView == self.timePickerView) {
        return [NSString stringWithFormat:@"%@",self.minutes[row]];
    }
    
    return  @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   if (pickerView == self.soundPickerView) {
        NSArray *soundNames = [self.sounds[row] componentsSeparatedByString:@"."];
        self.soundField.text = soundNames[0];
    } else if (pickerView == self.timePickerView) {
        NSString *alertTextfieldText = [self formatTimeLabel:[self.minutes[row] integerValue]];
        self.alertTimeField.text = alertTextfieldText;
    }
}

@end
