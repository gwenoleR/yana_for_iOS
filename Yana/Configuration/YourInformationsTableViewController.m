//
//  YourInformationsTableViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "YourInformationsTableViewController.h"

@interface YourInformationsTableViewController () {
    NSArray *set;
    UIAlertView *alert;
    NSUserDefaults *standardUserDefaults;
}

@end

@implementation YourInformationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///////// HICE EMPTY CELL ON BOTTOM AND RENAME THE BACK BUTTON ///////
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.backBarButtonItem.title = @"";
    set = @[@"Sexe", @"Votre nom", @"votre prénom",@"Votre pseudonyme"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *message = nil;
    
    if (indexPath.row == 0) {
        message = @"0 : Mademoiselle, 1 : Madame, 2 : Monsieur";
    }
    
    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[set objectAtIndex:indexPath.row]] message:message delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"OK"];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    if (![[self getSettings:alert.title] isEqualToString:@"(null)"]) {
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.text = [self getSettings:alert.title];
    }
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ////// DO ACTION BY PRESSING "OK" BUTTON ///////
    if (buttonIndex == 1) {
        [self saveSettings:[[alertView textFieldAtIndex:0] text] inThis:alertView.title];
    }
    
}

-(void)saveSettings:(NSString *)data inThis:(NSString *)parameter {
    
    /////// VERIFY AND SAVE USER SETTINGS IN STANDARDUSERDEFAULT (SESSION VAR) /////////
    NSMutableArray *valueToSet = [[NSMutableArray alloc] initWithCapacity: 4];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"Sexe", @"Votre nom", @"votre prénom",@"Votre pseudonyme", nil] atIndex: 0];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"userSexe", @"userLastName", @"userName", @"userPseudo", nil] atIndex: 1];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    int i;
    for (i=0; i<4; i++) {
        if ([[[valueToSet objectAtIndex:0] objectAtIndex:i] isEqualToString:parameter]) {
            [standardUserDefaults setObject:data forKey:[[valueToSet objectAtIndex:1] objectAtIndex:i]];
            [standardUserDefaults synchronize];
        }
    }
    
}

-(NSString *)getSettings:(NSString *)parameter {
    
    ///////// VERIFY AND LOAD USER SETTINGS ///////
    NSString *data;
    NSMutableArray *valueToSet = [[NSMutableArray alloc] initWithCapacity: 4];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"Sexe", @"Votre nom", @"votre prénom",@"Votre pseudonyme", nil] atIndex: 0];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"userSexe", @"userLastName", @"userName", @"userPseudo", nil] atIndex: 1];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    int i;
    for (i=0; i<4; i++) {
        if ([[[valueToSet objectAtIndex:0] objectAtIndex:i] isEqualToString:parameter]) {
            data = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:[[valueToSet objectAtIndex:1] objectAtIndex:i]]];
        }
    }
    return data;
}

@end
