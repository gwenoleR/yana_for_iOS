//
//  ConfigWidget.m
//  Yana
//
//  Created by Gwénolé Roton on 02/07/2015.
//  Copyright (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "ConfigWidget.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ConfigWidget (){
    NSUserDefaults *standardUserDefaults;
    NSString *savedServer;
    NSString *savedToken;
    NSMutableArray *Liste;
    NSUserDefaults *mySharedDefaults;
}

@end

@implementation ConfigWidget

- (void)viewDidLoad {
    [super viewDidLoad];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    if ([[[NSUserDefaults standardUserDefaults]  valueForKey:@"useWeb"] isEqualToString:@"YES"]) {
        if ([self checkNetwork]) {
            savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIP"]];
        }
        else {
            savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIPExt"]];
        }
    }
    else{
        savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIP"]];
    }
    savedToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"userToken"]];
    
    
    NSString *urlData;
    NSError *error = nil;
    urlData = [NSString stringWithFormat:@"http://%@/yana-server/action.php?action=GET_SPEECH_COMMAND&token=%@",savedServer,savedToken];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    if (jsonData) {
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        
        NSArray *entries = [jsonObjects objectForKey:@"commands"];
        Data = [NSArray arrayWithObjects:
                [NSMutableArray array],
                [NSMutableArray array], nil];
        
        
        
        if(entries != (id)[NSNull null])
        {
            
            for (NSDictionary *item in entries)
            {
                if ([item objectForKey:@"command"] && [item objectForKey:@"url"]) {
                    [[Data objectAtIndex:0] addObject:[item objectForKey:@"command"]];
                    [[Data objectAtIndex:1] addObject:[item objectForKey:@"url"]];
                }
            }
        }
        
        Liste = [NSMutableArray arrayWithObjects:
                 [NSMutableArray array],
                 [NSMutableArray array], nil];

        [[Liste objectAtIndex:0] addObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget1"]];
        [[Liste objectAtIndex:1] addObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse1"]];
        [[Liste objectAtIndex:0] addObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget2"]];
        [[Liste objectAtIndex:1] addObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse2"]];

     
        if([[Liste objectAtIndex:0] count]==2){
            if ([[[Liste objectAtIndex:0] objectAtIndex:0] isEqual:@"Aucune commande"]) {
                [[Liste objectAtIndex:0] removeObjectAtIndex:0];
                [[Liste objectAtIndex:1] removeObjectAtIndex:0];
            }
            if ([[[Liste objectAtIndex:0] objectAtIndex:0] isEqual:@"Aucune commande"]) {
                [[Liste objectAtIndex:0]removeObjectAtIndex:0];
                [[Liste objectAtIndex:1] removeObjectAtIndex:0];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[Data objectAtIndex:0] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [[Data objectAtIndex:0] objectAtIndex:indexPath.row];
    
    if([[Liste objectAtIndex:0] containsObject:[[Data objectAtIndex:0] objectAtIndex:indexPath.row]]) //hear selected list is an mutable array wich holds only selected player
    {
        cell.selected = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.selected = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.Easy-Yana"];
    
    if(cell)
    {
        if(cell.accessoryType == UITableViewCellAccessoryNone )
        {
            [[Liste objectAtIndex:0] addObject:[[Data objectAtIndex:0] objectAtIndex:indexPath.row]];
            [[Liste objectAtIndex:1] addObject:[[Data objectAtIndex:1] objectAtIndex:indexPath.row]];//add
        }
        else
        {
            if([[Liste objectAtIndex:0] containsObject:[[Data objectAtIndex:0] objectAtIndex:indexPath.row]])
            {
                [[Liste objectAtIndex:0] removeObject:[[Data objectAtIndex:0] objectAtIndex:indexPath.row]]; //remove
                [[Liste objectAtIndex:1] removeObject:[[Data objectAtIndex:1] objectAtIndex:indexPath.row]];
            }
        }
    }
    [tableView reloadData];
    
    switch ([[Liste objectAtIndex:0] count]) {
        case 0:
            NSLog(@"Case 0");
           
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"widget1"];
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"reponse1"];
           
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"widget2"];
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"reponse2"];
            
            break;
            
        case 1:
            NSLog(@"Case 1");
            
            [standardUserDefaults setObject:[[Liste objectAtIndex:0]objectAtIndex:0] forKey:@"widget1"];
            [standardUserDefaults setObject:[[Liste objectAtIndex:1]objectAtIndex:0] forKey:@"reponse1"];
            
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"widget2"];
            [standardUserDefaults setObject:@"Aucune commande" forKey:@"reponse2"];
            
            break;
            
        case 2:
            NSLog(@"Case 2");
            
            [standardUserDefaults setObject:[[Liste objectAtIndex:0] objectAtIndex:0] forKey:@"widget1"];
            [standardUserDefaults setObject:[[Liste objectAtIndex:1] objectAtIndex:0] forKey:@"reponse1"];
            
            [standardUserDefaults setObject:[[Liste objectAtIndex:0] objectAtIndex:1] forKey:@"widget2"];
            [standardUserDefaults setObject:[[Liste objectAtIndex:1] objectAtIndex:1] forKey:@"reponse2"];
            break;
            
        default:
            break;
    }
    
    [standardUserDefaults synchronize];
    
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget1"] forKey:@"commande1"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse1"] forKey:@"reponse1"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget2"] forKey:@"commande2"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse2"] forKey:@"reponse2"];
    
    [mySharedDefaults synchronize];
    
}

- (BOOL)checkNetwork {
    
    //////// CHECK THE SSID OF THE WIFI ///////
    CFArrayRef myArray = CNCopySupportedInterfaces();
     CFDictionaryRef captiveNtwrkDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
     NSDictionary *dict = (__bridge NSDictionary*) captiveNtwrkDict;
     NSString* ssid = [dict objectForKey:@"SSID"];
     if ([[[NSUserDefaults standardUserDefaults]  valueForKey:@"networkSSID"] isEqualToString:ssid]) {
         return YES;
     }
     else {
    return NO;
     }
}

@end
