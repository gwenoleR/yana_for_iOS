//
//  AsstConf5ViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsstConf5ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *events;

@property (weak, nonatomic) IBOutlet UISwitch *commands;

@property (weak, nonatomic) IBOutlet UISwitch *welcome;

@property (weak, nonatomic) IBOutlet UISwitch *TTS;

- (IBAction)Next:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *State;
@end
