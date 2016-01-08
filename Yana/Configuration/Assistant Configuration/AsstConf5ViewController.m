//
//  AsstConf5ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import "AsstConf5ViewController.h"

@interface AsstConf5ViewController ()

@end

@implementation AsstConf5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.State.progress = 0.80f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    
    if ([[standardUserDefaults objectForKey:@"setEvent"] isEqualToString:@"YES"]) {
        self.events.on = YES;
    } else {
        self.events.on = NO;
    }
    
    if ([[standardUserDefaults objectForKey:@"startUpdateCMD"] isEqualToString:@"YES"]) {
        self.commands.on = YES;
    } else {
        self.commands.on = NO;
    }
    
    if ([[standardUserDefaults objectForKey:@"startWelcomeMessage"] isEqualToString:@"YES"]) {
        self.welcome.on = YES;
    } else {
        self.welcome.on = NO;
    }
    
    if ([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]) {
        self.TTS.on = YES;
    } else {
        self.TTS.on = NO;
    }
    
    
}


- (IBAction)Next:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    
    if(self.events.on){
    [standardUserDefaults setObject:@"YES" forKey:@"setEvent"];
    [standardUserDefaults synchronize];
    }
    else{
        [standardUserDefaults setObject:@"NO" forKey:@"setEvent"];
        [standardUserDefaults synchronize];
    }
    
    if(self.commands.on){
        [standardUserDefaults setObject:@"YES" forKey:@"startUpdateCMD"];
        [standardUserDefaults synchronize];
    }
    else{
        [standardUserDefaults setObject:@"NO" forKey:@"startUpdateCMD"];
        [standardUserDefaults synchronize];
    }
    
    if(self.welcome.on){
        [standardUserDefaults setObject:@"YES" forKey:@"startWelcomeMessage"];
        [standardUserDefaults synchronize];
    }
    else{
        [standardUserDefaults setObject:@"NO" forKey:@"startWelcomeMessage"];
        [standardUserDefaults synchronize];
    }
    
    if(self.TTS.on){
        [standardUserDefaults setObject:@"YES" forKey:@"startTTS"];
        [standardUserDefaults synchronize];
    }
    else{
        [standardUserDefaults setObject:@"NO" forKey:@"startTTS"];
        [standardUserDefaults synchronize];
    }
    
}
@end
