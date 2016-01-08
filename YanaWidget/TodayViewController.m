//
//  TodayViewController.m
//  YanaWidget
//
//  Created by Gwénolé Roton on 01/07/2015.
//  Copyright (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;
- (IBAction)button:(id)sender;
- (IBAction)button1:(id)sender;

@end

@implementation TodayViewController
NSUserDefaults *mySharedDefaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.Easy-Yana"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    self.label.text = @"Hello Yana";
    
    
    self.label.text = [mySharedDefaults objectForKey:@"commande1"];
    self.label1.text = [mySharedDefaults objectForKey:@"commande2"];
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)button:(id)sender {
    self.label.text = [mySharedDefaults objectForKey:@"reponse1"];
    
    NSString *token = [mySharedDefaults objectForKey:@"token"];
    
    NSString *urlData;
    NSError *error = nil;
    urlData = [NSString stringWithFormat:@"%@&token=%@",[mySharedDefaults objectForKey:@"reponse1"],token];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    NSArray *entries = [jsonObjects objectForKey:@"responses"];
    NSArray *reponse = [NSArray arrayWithObjects:
               [NSMutableArray array],
               [NSMutableArray array], nil];
    
    
    if(entries != (id)[NSNull null])
    {
        
        for (NSDictionary *item in entries)
        {
            if([[item objectForKey:@"type"]isEqualToString:(@"talk")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"sentence"]];
            }
            else if([[item objectForKey:@"type"]isEqualToString:(@"command")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"program"]];
            }
        }
    }
    
    for(int i=0;i< [[reponse objectAtIndex:0]count];i++){
        self.label.text = [[reponse objectAtIndex:1] objectAtIndex:i];
    }

    
}

- (IBAction)button1:(id)sender {
    
    self.label1.text = [mySharedDefaults objectForKey:@"reponse2"];
    
    NSString *token = [mySharedDefaults objectForKey:@"token"];
    
    NSString *urlData;
    NSError *error = nil;
    urlData = [NSString stringWithFormat:@"%@&token=%@",[mySharedDefaults objectForKey:@"reponse2"],token];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    NSArray *entries = [jsonObjects objectForKey:@"responses"];
    NSArray *reponse = [NSArray arrayWithObjects:
                        [NSMutableArray array],
                        [NSMutableArray array], nil];
    
    
    if(entries != (id)[NSNull null])
    {
        
        for (NSDictionary *item in entries)
        {
            if([[item objectForKey:@"type"]isEqualToString:(@"talk")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"sentence"]];
            }
            else if([[item objectForKey:@"type"]isEqualToString:(@"command")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"program"]];
            }
        }
    }
    
    for(int i=0;i< [[reponse objectAtIndex:0]count];i++){
        self.label1.text = [[reponse objectAtIndex:1] objectAtIndex:i];
    }
    
}
@end
