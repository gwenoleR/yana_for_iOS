//
//  ConfigurationViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController () {
    NSUserDefaults *standardUserDefaults;
}

@end

@implementation ConfigurationViewController
@synthesize tableView1, tableView2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///////// ADJUST THE TEXTFIELD AT BOTTOM AND RENAME THE BACK BUTTON ///////
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem.title = @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    /////// FIRST TABLEVIEW ///////
    if (tableView == tableView1) {
        return 3;
    }
    /////// SECOND TABLEVIEW ///////
    else if (tableView == tableView2){
    return 2;
    }
    else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /////// EMAIL PRESSED CELL --> SHOW POPUP //////
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tableView2) {
        if (indexPath.row == 1) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Votre e-mail pour vous contacter" message:nil delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"userEmail"];
            [alert show];
        }
        else if(indexPath.row==0){
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:nil];
            UIViewController *add =
            [storyboard instantiateViewControllerWithIdentifier:@"AssistantInstall"];
            
            [self presentViewController:add
                               animated:YES
                             completion:nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ////// DO ACTION BY PRESSING "OK" BUTTON ///////
    if (buttonIndex == 1) {
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setObject:[[alertView textFieldAtIndex:0] text] forKey:@"userEmail"];
        [standardUserDefaults synchronize];
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //////// ADD STATIC CELL FOR TB1 & TB2 /////////
    if (tableView == tableView1) {
        if (indexPath.row == 0) return self.cellOne;
        if (indexPath.row == 1) return self.cellTwo;
        if (indexPath.row == 2) return self.cellThree;
    }
    else if (tableView == tableView2){
        if (indexPath.row == 0) return self.cellFor;
        if (indexPath.row == 1) return self.cellFive;
    }

    return nil;
}

- (IBAction)don:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MFXATF7EMBFM4"]];
}
@end
