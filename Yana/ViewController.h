//
//  ViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 29/11/2014.
//  Copyleft (c) 2014 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpeechSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, ISSpeechRecognitionDelegate>
{
    SystemSoundID SoundId;
    NSMutableArray *maListe;
    NSMutableArray *commandVoc;
    NSMutableArray *monchat;
    NSArray *reponse;
    AVSpeechSynthesizer* mySynthesizer;
    NSInteger selectRow;
}

@property (weak, nonatomic) IBOutlet UILabel *resultat;
@property (nonatomic, strong) ISSpeechRecognition *recognition;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *pickerViewTextField;

@property (retain, nonatomic) NSArray *commandList;
@property (retain, nonatomic) NSArray *commandListV2;

@property (retain, nonatomic) NSMutableArray *monchat;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;

@property (weak, nonatomic) IBOutlet UIView *pv;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *actionLink;
- (IBAction)doneButton:(id)sender;
- (IBAction)commandRenew:(id)sender;
- (IBAction)commandList:(id)sender;
- (IBAction)goToWeb:(id)sender;
- (IBAction)micro:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItem2;

@end