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
    self.sounds = @[@"Default.mp3", @"Default.mp3", @"Default.mp3"];
    
    self.alertTimeField.text = [NSString stringWithString:[self formatTimeLabel:CUELGAStoreMinutes]];
    self.soundField.text = [NSString stringWithString:CUELGAStoreSound];
    
    self.alertTimeField.inputView = [self createTimePickerView];
    self.soundField.inputView = [self createSoundPickerView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSString *)formatTimeLabel:(NSInteger)storedNumber {
    
    NSMutableString *alertTextfieldText = [NSMutableString stringWithFormat:@"%ld minuto",(long)storedNumber];
    
    if (storedNumber != 1) {
        [alertTextfieldText appendString:@"s"];
    }
    
    return alertTextfieldText;
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

- (void)didTapDoneFromPicker {
    [self.view endEditing:YES];
    
    NSInteger selectedRow = [self.timePickerView selectedRowInComponent:0];
    [DNPStoreSettings setObject:self.minutes[selectedRow] forKey:@"storeMinutes"];
}

- (UIView *)createSoundPickerView
{
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
    UIBarButtonItem *barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didTapDoneFromPicker)];
    barButtonNext.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [[NSArray alloc] initWithObjects:flex, barButtonNext, nil];
    
    [containerPickerView addSubview:toolBar];
    [containerPickerView addSubview:self.soundPickerView];
    
    NSInteger storedIndex = CUELGAStoreMinutes;
    [self.soundPickerView selectRow:storedIndex inComponent:0 animated:YES];
    
    return containerPickerView;
}

- (UIView *)createTimePickerView
{
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
    [self.timePickerView selectRow:storedIndex inComponent:0 animated:YES];
    
    return containerPickerView;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.soundPickerView) {
        return self.sounds.count;
    } else if (pickerView == self.timePickerView) {
        return self.minutes.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.soundPickerView) {
        return [NSString stringWithFormat:@"%@",self.sounds[row]];
    } else if (pickerView == self.timePickerView) {
        return [NSString stringWithFormat:@"%@",self.minutes[row]];
    }
    
    return  @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //TODO:translate this
    if (pickerView == self.soundPickerView) {
        
        NSString *alertTextfieldText = [NSString stringWithFormat:@"%@",self.sounds[row]];
        self.soundField.text = alertTextfieldText;
    } else if (pickerView == self.timePickerView) {
       
        NSString *alertTextfieldText = [self formatTimeLabel:[self.minutes[row] integerValue]];
        self.alertTimeField.text = alertTextfieldText;
    }
}

@end
