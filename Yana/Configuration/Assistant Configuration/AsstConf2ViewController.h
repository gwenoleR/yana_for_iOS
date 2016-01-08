//
//  AsstConf2ViewController.h
//  Yana
//
//  Created by Gwénolé Roton on 05/01/2015.
//  Copyleft (c) 2015 Gwénolé Roton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsstConf2ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *State;
@property (weak, nonatomic) IBOutlet UIPickerView *Sexe;

- (IBAction)Next:(id)sender;
@end
