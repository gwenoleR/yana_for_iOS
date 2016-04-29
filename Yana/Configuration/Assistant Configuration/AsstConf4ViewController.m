//
//  AsstConf4ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf4ViewController.h"

@interface AsstConf4ViewController () {
    CGPoint originalCenter;
}

@end

@implementation AsstConf4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.SSID.delegate = self;
    self.State.progress = 0.64f;
    self->originalCenter = self.view.center;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    if (![[standardUserDefaults objectForKey:@"useWeb"] isEqualToString:@"YES"]) {
        [self.SSID setHidden:YES];
        [self.IPext setHidden:YES];
        [self.text1 setHidden:YES];
        [self.text2 setHidden:YES];
    }
    else {
        [self.SSID setHidden:NO];
        [self.IPext setHidden:NO];
        [self.text1 setHidden:NO];
        [self.text2 setHidden:NO];
    }
    
    
    if ([[NSString stringWithFormat:@"%@",[standardUserDefaults objectForKey:@"newSavedServer"]] isEqualToString:@"(null)"]){
        [standardUserDefaults setValue:@"1" forKey:@"newSavedServer"];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nouveautés"
                                             message:@"Il y a des nouveautés ! Merci de mettre à jour l'ip interne et externe de votre serveur !"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [message show];
        [standardUserDefaults setValue:@"" forKey:@"serverIP"];
        [standardUserDefaults setValue:@"" forKey:@"serverIPExt"];
    }
    
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    self.IPint.text = [standardUserDefaults objectForKey:@"serverIP"];
    self.SSID.text = [standardUserDefaults objectForKey:@"networkSSID"];
    self.IPext.text = [standardUserDefaults objectForKey:@"serverIPExt"];
    self.Token.text = [standardUserDefaults objectForKey:@"userToken"];

    
    
    
}
- (IBAction)Start:(id)sender {
    [UIView transitionWithView:self.Title duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    self.Title.hidden = YES;
    [UIView transitionWithView:self.State duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.State.hidden = YES;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    if ([[standardUserDefaults objectForKey:@"useWeb"] isEqualToString:@"YES"]) {

        [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
        self.view.center = CGPointMake(self->originalCenter.x, self->originalCenter.y - 65);
        [UIView commitAnimations];

    }

    
}

- (IBAction)Stop:(id)sender {
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    self.view.center = self->originalCenter;
    [UIView commitAnimations];
    [UIView transitionWithView:self.Title duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.Title.hidden = NO;
    [UIView transitionWithView:self.State duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.State.hidden = NO;
}

- (IBAction)Next:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:self.IPint.text forKey:@"serverIP"];
    [standardUserDefaults setObject:self.SSID.text forKey:@"networkSSID"];
    [standardUserDefaults setObject:self.IPext.text forKey:@"serverIPExt"];
    [standardUserDefaults setObject:self.Token.text forKey:@"userToken"];
    [standardUserDefaults setObject:@"9999" forKey:@"socketPort"];
    
    [standardUserDefaults setValue:@"1" forKey:@"newSavedServer"];
    
    [standardUserDefaults synchronize];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.IPint){
        [self.SSID becomeFirstResponder];
    }
    else if(textField == self.SSID){
        [self.IPext becomeFirstResponder];
    }
    else if(textField == self.IPext){
        [self.view endEditing:YES];
    }
    
    
    return YES;
    
}


- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

@end
