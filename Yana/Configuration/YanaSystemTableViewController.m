//
//  YanaSystemTableViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "YanaSystemTableViewController.h"

@interface YanaSystemTableViewController () {
    NSArray *set;
    UIAlertView *alert;
    NSUserDefaults *standardUserDefaults;
}

@end

@implementation YanaSystemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /////////SET NAME TO POPUP, HIDE EMPTY CELL ON BOTTOM AND RENAME THE BACK BUTTON ///////
    set = @[@"Adresse de la page (interne)", @"", @"Adresse de la page (externe)",@"Nom du réseau local connecté au Raspberry"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.backBarButtonItem.title = @"";
}

-(void)viewDidAppear:(BOOL)animated{
    ////// GET USER SETTINGS ///////
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    
    ////// CHANGE THE TYPE OF THE WEB ACCESS STATE //////
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"useWeb"] isEqualToString:@"YES"]) {
        self.cell2.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (self.cell2.accessoryType == UITableViewCellAccessoryNone) {
        self.cell3.userInteractionEnabled = NO;
        self.cell4.userInteractionEnabled = NO;
        self.cell3.textLabel.textColor = [UIColor grayColor];
        self.cell3.detailTextLabel.textColor = [UIColor grayColor];
        self.cell4.textLabel.textColor = [UIColor grayColor];
        self.cell4.detailTextLabel.textColor = [UIColor grayColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1)
    {
        ////// CHANGE THE STATE OF THE WEB ACCESS CELL & CHANGE THE DESIGN OF EXTERNE IP AND SSID CELL //////
        if(self.cell2.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            self.cell2.accessoryType = UITableViewCellAccessoryNone;
            self.cell3.userInteractionEnabled = NO;
            self.cell4.userInteractionEnabled = NO;
            self.cell3.textLabel.textColor = [UIColor grayColor];
            self.cell3.detailTextLabel.textColor = [UIColor grayColor];
            self.cell4.textLabel.textColor = [UIColor grayColor];
            self.cell4.detailTextLabel.textColor = [UIColor grayColor];
            [standardUserDefaults setObject:@"NO" forKey:@"useWeb"];
            [standardUserDefaults synchronize];
        }
        else
        {
            self.cell2.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cell3.userInteractionEnabled = YES;
            self.cell4.userInteractionEnabled = YES;
            self.cell3.textLabel.textColor = [UIColor blackColor];
            self.cell3.detailTextLabel.textColor = [UIColor blackColor];
            self.cell4.textLabel.textColor = [UIColor blackColor];
            self.cell4.detailTextLabel.textColor = [UIColor blackColor];
            [standardUserDefaults setObject:@"YES" forKey:@"useWeb"];
            [standardUserDefaults synchronize];
        }
    }
    
    //////// FIRST SECTION SELECTED CELL --> SHOW POPUP /////
    if (indexPath.row != 1 && indexPath.section == 0) {
    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[set objectAtIndex:indexPath.row]] message:nil delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"OK"];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        if (![[self getSettings:alert.title] isEqualToString:@"(null)"]) {
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.text = [self getSettings:alert.title];
        }
    [alert show];
    }
    
    //////// SECOND SECTION SELECTED CELL --> SHOW POPUP /////
    else if (indexPath.section == 1){
        alert = [[UIAlertView alloc] initWithTitle:@"Token permettant de vous identifier" message:nil delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"OK"];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        if (![[self getSettings:alert.title] isEqualToString:@"(null)"]) {
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.text = [self getSettings:alert.title];
        }
        [alert show];
    }

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
    [valueToSet insertObject: [NSArray arrayWithObjects: @"Adresse de la page (interne)", @"Adresse de la page (externe)", @"Nom du réseau local connecté au Raspberry", @"Token permettant de vous identifier", nil] atIndex: 0];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"serverIP", @"serverIPExt", @"networkSSID", @"userToken", nil] atIndex: 1];
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
    [valueToSet insertObject: [NSArray arrayWithObjects: @"Adresse de la page (interne)", @"Adresse de la page (externe)", @"Nom du réseau local connecté au Raspberry", @"Token permettant de vous identifier", nil] atIndex: 0];
    [valueToSet insertObject: [NSArray arrayWithObjects: @"serverIP", @"serverIPExt", @"networkSSID", @"userToken", nil] atIndex: 1];
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
