//
//  AsstConf6ViewController.m
//  Yana
//
//  Created by Gwénolé Ronto on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf6ViewController.h"

@interface AsstConf6ViewController () {
    NSUserDefaults *standardUserDefaults;
    NSMutableArray *userInfo;

}

@end

@implementation AsstConf6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.State.progress = 1.0f;
    userInfo = [[NSMutableArray alloc] initWithCapacity: 10];

    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud synchronize];
    [userInfo insertObject:[NSArray arrayWithObjects:@"NOM",@"PRÉNOM",@"PSEUDO",@"LIEN INTERNE",@"NOM DU RÉSEAU LOCAL",@"LIEN EXTERNE",@"VOUS ÊTES UN(E)...",@"YANA VIA INTERNET",@"TOKEN",@"ACTIVER...", nil]atIndex:0];
    [userInfo insertObject:[NSArray arrayWithObjects:
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"userLastName"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"userName"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"userPseudo"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"serverIP"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"networkSSID"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"serverIPExt"]],
                            [self getSexe:[[sud objectForKey:@"userSexe"] integerValue]],
                            [self useWeb:[sud objectForKey:@"useWeb"]],
                            [NSString stringWithFormat:@"%@",[sud objectForKey:@"userToken"]],
                            [self activer], nil] atIndex:1];
    
     NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.Easy-Yana"];
    
    [standardUserDefaults setObject:@"Aucune commande" forKey:@"widget1"];
    [standardUserDefaults setObject:@"" forKey:@"reponse1"];
    [standardUserDefaults setObject:@"Aucune commande" forKey:@"widget2"];
    [standardUserDefaults setObject:@"" forKey:@"reponse2"];
    
    if([[sud objectForKey:@"userToken"] isEqualToString:@""]){
        [standardUserDefaults setObject:@"0" forKey:@"userToken"];
    }
    else {
        [standardUserDefaults setObject:[sud objectForKey:@"userToken"] forKey:@"userToken"];
    }
    
    
    
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget1"] forKey:@"commande1"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse1"] forKey:@"reponse1"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"widget2"] forKey:@"commande2"];
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"reponse2"] forKey:@"reponse2"];
    
    [mySharedDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recap"];
    if ([[[userInfo objectAtIndex:1] objectAtIndex:indexPath.row] isEqualToString:@""] || [[[userInfo objectAtIndex:1] objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
        cell.detailTextLabel.text = @"(none)";
    }
    else {
        cell.detailTextLabel.text = [[userInfo objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [[userInfo objectAtIndex:0] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *longString = [[userInfo objectAtIndex:1]objectAtIndex:indexPath.row];
    
    
    UIFont *cellFont      = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGSize constraintSize = CGSizeMake(91.0f, 2000);
    CGSize suggestedSize  = [longString
                             sizeWithFont:cellFont
                             constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByClipping];
    
    int suggestedSize2 = (int) suggestedSize.height + 10;
    
    //NSLog(@"Index : %ld , size : %d",indexPath.row,suggestedSize2);
    
    if (suggestedSize2 <= 40 ) {
        return 40;
    }
    else if(suggestedSize2 == 79){
        return 55;
    }
    else if(suggestedSize2 == 130){
        return 75;
    }
    else if(suggestedSize2 == 165){
        return 90;
    }
    else if(suggestedSize2 == 182){
        return 95;
    }
    else if(suggestedSize2 == 217){
        return 110;
    }
    else {
        return suggestedSize2 + 10;
    }
    
    
}

- (IBAction)Done:(id)sender {

    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:@"1" forKey:@"1stsTest"];
    [standardUserDefaults synchronize];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"mainStart"];
    
    [self presentViewController:add animated:NO completion:nil];
}

-(NSString *)getSexe:(NSInteger)number {
    NSArray *value = @[@"Mademoiselle",@"Madame",@"Monsieur"];
    NSString *sexe;
    int i;
    for (i=0; i<3; i++) {
        if (number == i) {
            sexe = [value objectAtIndex:i];
        }
    }
    
    return sexe;
}

-(NSString *)activer{
    
    NSString *activer=@"";
    NSInteger count=0;
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    
    if([[standardUserDefaults objectForKey:@"startUpdateCMD"] isEqualToString:@"YES"]){
        if(count>0) activer=[NSString stringWithFormat:@"%@, ",activer];
        activer = [NSString stringWithFormat:@"%@La mise à jour des commandes au démarrage",activer];
        count++;
    }
    if([[standardUserDefaults objectForKey:@"setEvent"] isEqualToString:@"YES"]){
        if(count>0) activer=[NSString stringWithFormat:@"%@, ",activer];
        activer = [NSString stringWithFormat:@"%@Les evenements",activer];
        count++;
    }
    if([[standardUserDefaults objectForKey:@"startWelcomeMessage"] isEqualToString:@"YES"]){
        if(count>0) activer=[NSString stringWithFormat:@"%@, ",activer];
        activer = [NSString stringWithFormat:@"%@Le message de bienvenue",activer];
        count++;
    }
    if([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]){
        if(count>0) activer=[NSString stringWithFormat:@"%@, ",activer];
        activer = [NSString stringWithFormat:@"%@Le Text To Speech",activer];
        count++;
    }
    return activer;
}

-(NSString *)useWeb:(NSString *)youn {

    NSString *useWeb;
    if ([youn isEqualToString:@"YES"]) {
        useWeb = @"Oui";
    }
    else if ([youn isEqualToString:@"NO"]){
        useWeb = @"Non";
    }
    else { useWeb = @""; }
    return useWeb;
}
@end
