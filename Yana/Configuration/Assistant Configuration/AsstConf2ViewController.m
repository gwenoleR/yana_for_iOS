//
//  AsstConf2ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf2ViewController.h"

@interface AsstConf2ViewController () {
    
    NSArray *pickerData;
    NSInteger userSexe;
    
}

@end

@implementation AsstConf2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.State.progress = 0.32f;
    pickerData = @[@"Mademoiselle", @"Madame", @"Monsieur"];
    
    self.Sexe.dataSource = self;
    self.Sexe.delegate = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void) viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];

    [self.Sexe selectRow:[[standardUserDefaults objectForKey:@"userSexe"] integerValue] inComponent:0 animated:YES];
    userSexe = [[standardUserDefaults objectForKey:@"userSexe"] integerValue];
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   userSexe = row;
}

- (IBAction)Next:(id)sender {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    [standardUserDefaults setObject:[NSString stringWithFormat:@"%ld",userSexe] forKey:@"userSexe"];
    [standardUserDefaults synchronize];
}
@end
