//
//  AsstConf1ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf1ViewController.h"

@interface AsstConf1ViewController () {
    
    CGPoint originalCenter;
}

@end

@implementation AsstConf1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Name.delegate = self;
    self.State.progress = 0.16f;
    self->originalCenter = self.view.center;
    [self.PreviousB setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    self.Name.text = [standardUserDefaults objectForKey:@"userName"];
    self.LastName.text = [standardUserDefaults objectForKey:@"userLastName"];
    self.Pseudo.text = [standardUserDefaults objectForKey:@"userPseudo"];


    
}
- (IBAction)Start:(id)sender {
    [UIView transitionWithView:self.WhoRU duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.WhoRU.hidden = YES;
    [UIView transitionWithView:self.State duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.State.hidden = YES;
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    self.view.center = CGPointMake(self->originalCenter.x, self->originalCenter.y - 65);
    [UIView commitAnimations];

}

- (IBAction)Stop:(id)sender {
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    self.view.center = self->originalCenter;
    [UIView commitAnimations];
    
    [UIView transitionWithView:self.WhoRU duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.WhoRU.hidden = NO;
    [UIView transitionWithView:self.State duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.State.hidden = NO;
}

- (IBAction)Next:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:self.Name.text forKey:@"userName"];
    [standardUserDefaults setObject:self.LastName.text forKey:@"userLastName"];
    [standardUserDefaults setObject:self.Pseudo.text forKey:@"userPseudo"];
    [standardUserDefaults synchronize];

}

- (IBAction)test:(id)sender {
    
    NSString *urlData;
    NSError *error = nil;
    urlData = [NSString stringWithFormat:@"http://ceipaf.fr/yana-server/userTest.php"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *entries = [jsonObjects objectForKey:@"response"];
        reponse = [NSArray arrayWithObjects:
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array], nil];
        
        
        
        if(entries != (id)[NSNull null])
        {
            
            for (NSDictionary *item in entries)
            {
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"userLastName"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"userName"]];
                [[reponse objectAtIndex:2] addObject:[item objectForKey:@"userPseudo"]];
                [[reponse objectAtIndex:3] addObject:[item objectForKey:@"serveurIP"]];
                [[reponse objectAtIndex:4] addObject:[item objectForKey:@"networkSSID"]];
                [[reponse objectAtIndex:5] addObject:[item objectForKey:@"serveurIPExt"]];
                [[reponse objectAtIndex:6] addObject:[item objectForKey:@"userSexe"]];
                [[reponse objectAtIndex:7] addObject:[item objectForKey:@"useWeb"]];
                [[reponse objectAtIndex:8] addObject:[item objectForKey:@"userToken"]];
                
            }
        }
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:[[reponse objectAtIndex:0] objectAtIndex:0] forKey:@"userLastName"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:1] objectAtIndex:0] forKey:@"userName"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:2] objectAtIndex:0] forKey:@"userPseudo"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:3] objectAtIndex:0] forKey:@"serverIP"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:4] objectAtIndex:0] forKey:@"networkSSID"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:5] objectAtIndex:0] forKey:@"serverIPExt"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:6] objectAtIndex:0] forKey:@"userSexe"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:7] objectAtIndex:0] forKey:@"useWeb"];
    [standardUserDefaults setObject:[[reponse objectAtIndex:8] objectAtIndex:0] forKey:@"userToken"];
    
    [standardUserDefaults setValue:@"1" forKey:@"newSavedServer"];
    
    
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.LastName){
        [self.Name becomeFirstResponder];
    }
    else if(textField == self.Name){
        [self.Pseudo becomeFirstResponder];
    }
    else if(textField == self.Pseudo){
        [self.view endEditing:YES];
        }
    
    
    return YES;
    
}


- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}



@end
