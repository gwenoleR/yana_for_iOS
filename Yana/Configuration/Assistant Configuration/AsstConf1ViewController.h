//
//  AsstConf1ViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AsstConf1ViewController : UIViewController <UITextFieldDelegate>{
    NSArray *reponse;
}


@property (weak, nonatomic) IBOutlet UIProgressView *State;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *Pseudo;
@property (weak, nonatomic) IBOutlet UILabel *WhoRU;
@property (weak, nonatomic) IBOutlet UIButton *NextB;
@property (weak, nonatomic) IBOutlet UIButton *PreviousB;


- (IBAction)Start:(id)sender;
- (IBAction)Stop:(id)sender;
- (IBAction)Next:(id)sender;
- (IBAction)test:(id)sender;



- (IBAction)backgroundTap:(id)sender;
@end
