//
//  YanaForiOSTableViewController.m
//  Yana
//
//  Created by Gwénolé Ronto on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "YanaForiOSTableViewController.h"

@interface YanaForiOSTableViewController () {
    NSUserDefaults *standardUserDefaults;

}

@end

@implementation YanaForiOSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    [self showParameters];
}

-(void) showParameters {
    
    if ([[standardUserDefaults objectForKey:@"setEvent"] isEqualToString:@"YES"]) {
        self.cell0.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.cell0.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([[standardUserDefaults objectForKey:@"startUpdateCMD"] isEqualToString:@"YES"]) {
        self.cell1.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.cell1.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([[standardUserDefaults objectForKey:@"startWelcomeMessage"] isEqualToString:@"YES"]) {
        self.cell2.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.cell2.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]) {
        self.cell3.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.cell3.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    NSLog(@"0 0 is pressed");
                    if (cell.accessoryType == UITableViewCellAccessoryNone) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        [standardUserDefaults setObject:@"YES" forKey:@"setEvent"];
                        [standardUserDefaults synchronize];
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        [standardUserDefaults setObject:@"NO" forKey:@"setEvent"];
                        [standardUserDefaults synchronize];
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    NSLog(@"1 0 is pressed");
                    if (cell.accessoryType == UITableViewCellAccessoryNone) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        [standardUserDefaults setObject:@"YES" forKey:@"startUpdateCMD"];
                        [standardUserDefaults synchronize];
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        [standardUserDefaults setObject:@"NO" forKey:@"startUpdateCMD"];
                        [standardUserDefaults synchronize];
                    }
                    break;
                case 1:
                    NSLog(@"1 1 is pressed");
                    if (cell.accessoryType == UITableViewCellAccessoryNone) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        [standardUserDefaults setObject:@"YES" forKey:@"startWelcomeMessage"];
                        [standardUserDefaults synchronize];
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        [standardUserDefaults setObject:@"NO" forKey:@"startWelcomeMessage"];
                        [standardUserDefaults synchronize];
                    }
                default:
                    break;
            }
            break;
        case 2:
            if(cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSLog(@"TTS coché");
                [standardUserDefaults setObject:@"YES" forKey:@"startTTS"];
                [standardUserDefaults synchronize];

            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                NSLog(@"TTS décoché");
                [standardUserDefaults setObject:@"NO" forKey:@"startTTS"];
                [standardUserDefaults synchronize];
            }
        default:
            break;
    }


    
}
@end
