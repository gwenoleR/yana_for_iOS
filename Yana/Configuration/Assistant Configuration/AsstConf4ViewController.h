//
//  AsstConf4ViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 06/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsstConf4ViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIProgressView *State;
@property (weak, nonatomic) IBOutlet UITextField *IPint;
@property (weak, nonatomic) IBOutlet UITextField *SSID;
@property (weak, nonatomic) IBOutlet UITextField *IPext;
@property (weak, nonatomic) IBOutlet UITextField *Token;
@property (weak, nonatomic) IBOutlet UITextField *SocketPort;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;


- (IBAction)Start:(id)sender;
- (IBAction)Stop:(id)sender;
- (IBAction)Next:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@end
