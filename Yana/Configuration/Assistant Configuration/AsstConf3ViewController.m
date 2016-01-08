//
//  AsstConf3ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf3ViewController.h"

@interface AsstConf3ViewController ()
{
    
    NSArray *pickerData;
    NSInteger userUseWeb;
    
}

@end

@implementation AsstConf3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.State.progress = 0.48f;
    pickerData = @[@"Oui", @"Non"];
    
    self.useWeb.dataSource = self;
    self.useWeb.delegate = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void) viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    NSArray *set = @[@"YES",@"NO"];
    int i;
    for (i=0; i<2; i++) {
        if ([[standardUserDefaults objectForKey:@"useWeb"] isEqualToString:[set objectAtIndex:i]]) {
        [self.useWeb selectRow:i inComponent:0 animated:YES];
            userUseWeb = i;
        }
    }
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
    userUseWeb = row;
}

- (IBAction)Next:(id)sender {
    NSArray *set = @[@"YES",@"NO"];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:[set objectAtIndex:userUseWeb] forKey:@"useWeb"];
    [standardUserDefaults synchronize];
}
@end
