//
//  ConfigurationViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

////// TB1 & TB2 ////////
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
- (IBAction)don:(id)sender;

///// STATIC CELL ////
@property (nonatomic, strong) IBOutlet UITableViewCell *cellOne;
@property (nonatomic, strong) IBOutlet UITableViewCell *cellTwo;
@property (nonatomic, strong) IBOutlet UITableViewCell *cellThree;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFor;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFive;

@end
