//
//  ViewController.m
//  Yana
//
//  Created by Gwénolé Roton on 29/11/2014.
//  Copyleft (c) 2014 Gwénolé Roton. All rights reserved.
//

#import "ViewController.h"
#import "ISSpeechRecognition.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation ViewController {
    NSUserDefaults *standardUserDefaults;
    NSString *savedServer;
    NSString *savedToken;
    UIAlertView *message;
}

@synthesize status,commandList,monchat,pv,recognition,commandListV2,inputStream, outputStream;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.Easy-Yana"];
    
    [super viewDidLoad];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    self.navigationItem.backBarButtonItem.title = @"";
    
    
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;
    
    [self assignServer];
    [self checkSetting];
    mySynthesizer = [[AVSpeechSynthesizer alloc] init];
    monchat = [NSMutableArray array];
    
    if ([[standardUserDefaults objectForKey:@"startUpdateCMD"] isEqualToString:@"YES"]) {
            [self refreshCommand];

    }
    
    //Initialise connection socket
    [self initSocketCommunication];
    
    //Demarrage des client V2
    [self startClientListen];
    [self startClientSpeaker];
    
    if([[standardUserDefaults objectForKey:@"userToken"] isEqualToString:@"0"] || [[standardUserDefaults objectForKey:@"userToken"] isEqualToString:@""]){
        
        message = [[UIAlertView alloc] initWithTitle:@"Error"
                                             message:@"Please enter a valid Token"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [self.buttonItem setEnabled:NO];
        [self.buttonItem2 setEnabled:NO];
        [message show];
        
    }


    
    //////////////// SHOW THE SAVED SERVER IN THE actionLink /////////////
    if (![savedServer isEqualToString:@"(null)"] || ![savedServer isEqualToString:@""]) {
        self.actionLink.text = [NSString stringWithFormat:@"%@/yana-server/action.php",savedServer];
    }


    ////////////// CHECK EVENT ////////////
    if ([[standardUserDefaults objectForKey:@"setEvent"] isEqualToString:@"YES"]) {
        NSTimer* Timer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self selector: @selector(checkEvent:) userInfo: nil repeats: YES];
    }

    
    if ([[standardUserDefaults objectForKey:@"startWelcomeMessage"] isEqualToString:@"YES"]) {
        

    ///// GENERATION DU MESSAGE ALEATOIRE ////
    int indexMessage = [self getRandomNumberBetween:0 to:2];
    
    NSArray *messageAlea = @[[NSString stringWithFormat:@"Bonjour monsieur %@",[standardUserDefaults objectForKey:@"userLastName"]],
                             [NSString stringWithFormat:@"Yo %@",[standardUserDefaults objectForKey:@"userPseudo"]],
                             [NSString stringWithFormat:@"Salut %@",[standardUserDefaults objectForKey:@"userName"]]];
    
    
    [monchat addObject:messageAlea[indexMessage]];
        
        
        NSString *text = [NSString stringWithFormat:@"%@",messageAlea[indexMessage]];
        
        if ([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]) {
            AVSpeechUtterance* myTestUtterance = [[AVSpeechUtterance alloc] initWithString:text];
        
            myTestUtterance.rate = 0.5;
            myTestUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-fr"];
            [mySynthesizer speakUtterance:myTestUtterance];
        }
        [self.tableView reloadData];
    }
    
    
    [mySharedDefaults setObject:[[NSUserDefaults standardUserDefaults]  valueForKey:@"userToken"] forKey:@"token"];
    [mySharedDefaults synchronize];
    
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

-(void) checkEvent:(NSTimer*) t
{
    

    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/yana-server/action.php?action=GET_EVENT&token=%@",savedServer,savedToken]] encoding:NO error:nil];
    
    if (connect == NULL) {

    }
    else {

    NSString *urlData;
    NSError *error = nil;
    
    urlData = [NSString stringWithFormat:@"http://%@/yana-server/action.php?action=GET_EVENT&token=%@",savedServer,savedToken];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    NSArray *entries = [jsonObjects objectForKey:@"responses"];
    reponse = [NSArray arrayWithObjects:
               [NSMutableArray array],
               [NSMutableArray array], nil];
    
    
    
    if(entries != (id)[NSNull null])
    {
        
        for (NSDictionary *item in entries)
        {
            if([[item objectForKey:@"type"]isEqualToString:(@"talk")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[item objectForKey:@"sentence"]];
            }
            else if([[item objectForKey:@"type"]isEqualToString:(@"sound")]){
                [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                [[reponse objectAtIndex:1] addObject:[NSString stringWithFormat:@" Joue le son : %@",[item objectForKey:@"file"]]];
                
                NSURL *buttonURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[item objectForKey:@"file"]] ofType:@"wav"]];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef) buttonURL, &SoundId );
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
                localNotification.alertBody = [NSString stringWithFormat:@"Le son %@.wav a été joué",[item objectForKey:@"file"]];
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
            }
        }
        
        for(int i=0;i< [[reponse objectAtIndex:0]count];i++){
            [monchat addObject:[[reponse objectAtIndex:1] objectAtIndex:i]];
            
            
            
            NSString *text = [NSString stringWithFormat:@"%@",[[reponse objectAtIndex:1] objectAtIndex:i]];
            
            AVSpeechUtterance* myTestUtterance = [[AVSpeechUtterance alloc] initWithString:text];
            

            myTestUtterance.rate = 0.2;
            myTestUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-fr"];
            [mySynthesizer speakUtterance:myTestUtterance];
            
        }
        
        
        AudioServicesPlaySystemSound(SoundId);
        
        [self.tableView reloadData];
    }
    
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [monchat count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    // Configuration de la cellule
    NSString *cellValue = [monchat objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    if ([[cell.textLabel.text substringToIndex:4] isEqualToString:@"YANA"]) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.backgroundColor = [UIColor colorWithRed:177.0/255.0 green:216.0/255.0 blue:237.0/255.0 alpha:1];
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:239.0/255.0 blue:250.0/255.0 alpha:1];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [maListe count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [maListe objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    selectRow = row;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *longString = [monchat objectAtIndex:indexPath.row];
    
    
    UIFont *cellFont      = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(280.0f, 2000);
    CGSize suggestedSize  = [longString
                             sizeWithFont:cellFont
                             constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    int suggestedSize2 = (int) suggestedSize.height + 30;
    
    
    if (suggestedSize2 <= 40 ) {
        return 40;
    }
    else {
        return suggestedSize2 + 10;
    }
    
}

- (void)viewDidUnload
{
    [self setPv:nil];
    //  [self setStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (IBAction)doneButton:(id)sender {
    
    [self.pickerViewTextField resignFirstResponder];
    
    [self sendCommand:[maListe objectAtIndex:selectRow]];
    
}

- (void)refreshCommand {
    
    if (![savedServer isEqualToString:@"(null)"] || ![savedServer isEqualToString:@""]) {
        self.actionLink.text = [NSString stringWithFormat:@"%@/yana-server/action.php",savedServer];
    }
    //////// REFRESH ALL COMMANDS //////////
    NSString *urlData;
    NSError *error = nil;
    urlData = [NSString stringWithFormat:@"http://%@/yana-server/action.php?action=GET_SPEECH_COMMAND&token=%@",savedServer,savedToken];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
    if (jsonData) {
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *entries = [jsonObjects objectForKey:@"commands"];
        commandList = [NSArray arrayWithObjects:
                       [NSMutableArray array],
                       [NSMutableArray array], nil];
        
        commandListV2 = [NSArray arrayWithObjects:
                         [NSMutableArray array],
                         [NSMutableArray array], nil];
        
        
        
        if(entries != (id)[NSNull null])
        {
            for (NSDictionary *item in entries)
            {
                if ([item objectForKey:@"command"] && [item objectForKey:@"url"]) {
                    [[commandList objectAtIndex:0] addObject:[item objectForKey:@"command"]];
                    [[commandList objectAtIndex:1] addObject:[item objectForKey:@"url"]];
                }
                else if([item objectForKey:@"command"] && [item objectForKey:@"callback"]){
                    [[commandListV2 objectAtIndex:0] addObject:[item objectForKey:@"command"]];
                    [[commandListV2 objectAtIndex:1] addObject:[item objectForKey:@"callback"]];
                }
            }
        }
        maListe = [[NSMutableArray alloc] init];
        commandVoc = [[NSMutableArray alloc] init];
        

        for(int i=0;i< [[commandList objectAtIndex:0]count];i++){
            [maListe addObject:[[commandList objectAtIndex:0] objectAtIndex:i]];
            
            /////// Création d'une liste sans virgule pour eviter les problemes a la reconnaissance vocale
            NSString *sansVir = [[commandList objectAtIndex:0] objectAtIndex:i];
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:;()$&@\".,?!\'[]{}#%^*+=_|~<>€£¥•."];
            sansVir = [[sansVir componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
            [commandVoc addObject:sansVir];
            
        }
        for(int i=0;i< [[commandListV2 objectAtIndex:0]count];i++){
            [maListe addObject:[[commandListV2 objectAtIndex:0] objectAtIndex:i]];
            
            NSLog(@"%@",[[commandListV2 objectAtIndex:0] objectAtIndex:i]);
            
            /////// Création d'une liste sans virgule pour eviter les problemes a la reconnaissance vocale
            NSString *sansVir = [[commandListV2 objectAtIndex:0] objectAtIndex:i];
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/:;()$&@\".,?!\'[]{}#%^*+=_|~<>€£¥•."];
            sansVir = [[sansVir componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
            [commandVoc addObject:sansVir];
            
        }
        
        [self.myPicker reloadAllComponents];
        [self.buttonItem setEnabled:YES];
        [self.buttonItem2 setEnabled:YES];
        
    }
    ////////// PRINT ERROR WHEN CAN'T GET JSONDATA //////////
    else {
        message = [[UIAlertView alloc] initWithTitle:@"Error"
                                             message:@"Check your connection"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [self.buttonItem setEnabled:NO];
        [self.buttonItem2 setEnabled:NO];
        [message show];
    }
    
    if([[standardUserDefaults objectForKey:@"userToken"] isEqualToString:@"0"] || [[standardUserDefaults objectForKey:@"userToken"] isEqualToString:@""]){
        
        message = [[UIAlertView alloc] initWithTitle:@"Error"
                                             message:@"Please enter a valid Token"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [self.buttonItem setEnabled:NO];
        [self.buttonItem2 setEnabled:NO];
        [message show];
    }
    
}

- (IBAction)commandRenew:(id)sender {
    //////////// BUTTON TO REFRESH COMMANDS ///////
    [self assignServer];
    [self checkSetting];
    [self refreshCommand];
    
}

- (IBAction)commandList:(id)sender {
    [self.pickerViewTextField becomeFirstResponder];
}

- (IBAction)goToWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.actionLink.text]]];
}



- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
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

- (void)checkSetting {
    
    /////////////// CHECK USER SETTINGS //////////////
    if ([[[NSUserDefaults standardUserDefaults]  valueForKey:@"useWeb"] isEqualToString:@"YES"]) {
        if ([ savedServer isEqualToString:@""]|| [ savedServer isEqualToString:@"(null)"] ||
            [ savedToken isEqualToString:@""]|| [ savedToken isEqualToString:@"(null)"] ||
            [[[NSUserDefaults standardUserDefaults]  valueForKey:@"networkSSID"] isEqualToString:@""] ||
            [[[NSUserDefaults standardUserDefaults]  valueForKey:@"networkSSID"] isEqualToString:@"(null)"] ||
            [[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIPExt"] isEqualToString:@""] ||
            [[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIPExt"] isEqualToString:@"(null)"]){
            
            message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                 message:@"Please, check your settings.."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            
            [message show];
        }
    }
    else {
        if ([ savedServer isEqualToString:@""]|| [ savedServer isEqualToString:@"(null)"] ||
            [ savedToken isEqualToString:@""]|| [ savedToken isEqualToString:@"(null)"]){
            
            message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                 message:@"Please, check your settings.."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            
            [message show];
        }
    }
}

///////// RECONNAISSANCE VOCALE /////
- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {

    NSLog(@"Result: %@", result.text);

    NSString *resultat;
    
    if ([result.text  isEqual: @""] || result.confidence < 0.4 ) {
        
        int indexMessage = [self getRandomNumberBetween:0 to:3];
        
        NSArray *messageAlea = @[[NSString stringWithFormat:@"Désolé, je n'ai pas compris."],
                                 [NSString stringWithFormat:@"Pardon ?"],
                                 [NSString stringWithFormat:@"Répétez s'il vous plait, je n'ai pas compris"],
                                 [NSString stringWithFormat:@"Commande inconnue.."]];
        
        resultat=messageAlea[indexMessage];
        [monchat addObject:resultat];
        [self.tableView reloadData];
        [self scrollToBottom];
        
        if([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]){
            AVSpeechUtterance* myTestUtterance = [[AVSpeechUtterance alloc] initWithString:resultat];
        

            myTestUtterance.rate = 0.5;
            myTestUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-fr"];
            [mySynthesizer speakUtterance:myTestUtterance];
        }
    }
    else{

        for(int i=0;i<[[commandList objectAtIndex:0]count];i++){
            NSString *string = [result.text substringWithRange:NSMakeRange(4, result.text.length-4)];
        
            NSString *commande = [[commandList objectAtIndex:0] objectAtIndex:i];
        
            if ([string rangeOfString:[commande substringWithRange:NSMakeRange(5, commande.length-5)]].location == NSNotFound) {
            } else {
                [self sendCommand:commande];
            }
        }
    }
    
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    NSLog(@"Error: %@", error);
}

- (IBAction)micro:(id)sender {
    recognition = [[ISSpeechRecognition alloc] init];
    [recognition setLocale:ISLocaleFRFrench];
    
    NSError *err;
    [recognition setDelegate:self];
    
    [recognition addAlias:@"command" forItems:commandVoc];
    [recognition addCommand:@"%command%"];
    
    if(![recognition listenAndRecognizeWithTimeout:10 error:&err]) {
        NSLog(@"ERROR: %@", err);
    }
}

- (void)assignServer {
    
    //////////////// USERDEFAULTS /////////////////
    
    //Get the user's settings and store in savedServer & savedToken
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults synchronize];
    if ([[[NSUserDefaults standardUserDefaults]  valueForKey:@"useWeb"] isEqualToString:@"YES"]) {
       /* if ([self checkNetwork]) {
            savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIP"]];
        }
        else { */
            savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIPExt"]];
       // }
    }
    else{
        savedServer = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"serverIP"]];
    }
    savedToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"userToken"]];
    
    
}

-(void)sendCommand:(NSString *)command{
    
   
    
    for(int i=0;i<[[commandList objectAtIndex:0]count];i++){
        if ([command isEqualToString:([NSString stringWithFormat:@"%@",[[commandList objectAtIndex:0] objectAtIndex:i]])])
        {
            
            NSLog(@"%@",[[commandList objectAtIndex:1] objectAtIndex:i]);
            
            [monchat addObject:command];
            
            [self.tableView reloadData];
            
            
            NSString *urlData;
            NSError *error = nil;
            urlData = [NSString stringWithFormat:@"%@&token=%@",[[commandList objectAtIndex:1] objectAtIndex:i],savedToken];
            
            NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlData]];
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            
            NSArray *entries = [jsonObjects objectForKey:@"responses"];
            reponse = [NSArray arrayWithObjects:
                       [NSMutableArray array],
                       [NSMutableArray array], nil];
            
            int z=1;
            
            
            if(entries != (id)[NSNull null])
            {
                
                for (NSDictionary *item in entries)
                {
                    if([[item objectForKey:@"type"]isEqualToString:(@"talk")]){
                        [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                        [[reponse objectAtIndex:1] addObject:[item objectForKey:@"sentence"]];
                    }
                    else if([[item objectForKey:@"type"]isEqualToString:(@"command")]){
                        [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                        [[reponse objectAtIndex:1] addObject:[item objectForKey:@"program"]];
                    }
                    else if([[item objectForKey:@"type"]isEqualToString:(@"sound")]){
                        [[reponse objectAtIndex:0] addObject:[item objectForKey:@"type"]];
                        [[reponse objectAtIndex:1] addObject:[NSString stringWithFormat:@" Joue le son : %@",[item objectForKey:@"file"]]];
                        
                        NSString* original=[item objectForKey:@"file"];
                        
                        for (NSUInteger i=0;i<[original length];i++)
                        {
                            if ([original characterAtIndex:i]=='.')
                            {
                                original=[original substringToIndex:i];
                            }
                        }

                        
                        NSURL *buttonURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:original ofType:@"wav"]];
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef) buttonURL, &SoundId );
                        AudioServicesPlaySystemSound(SoundId);
                        z=0;

                        
                    }

                }
            }
            
                for(int i=0;i< [[reponse objectAtIndex:0]count];i++){
                    [monchat addObject:[[reponse objectAtIndex:1] objectAtIndex:i]];
                    if([[standardUserDefaults objectForKey:@"startTTS"] isEqualToString:@"YES"]){
                        NSString *text = [NSString stringWithFormat:@"%@",[[reponse objectAtIndex:1] objectAtIndex:i]];
                
                        AVSpeechUtterance* myTestUtterance = [[AVSpeechUtterance alloc] initWithString:text];
                
                        myTestUtterance.rate = 0.5;
                        myTestUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-fr"];
                        if(z !=0){
                            [mySynthesizer speakUtterance:myTestUtterance];
                
                        }
                    }
                }
            
            
            [self.tableView reloadData];
            [self scrollToBottom];
            
        }
    }
    
    for(int i=0;i<[[commandListV2 objectAtIndex:0]count];i++){
        if([command isEqualToString:([NSString stringWithFormat:@"%@",[[commandListV2 objectAtIndex:0] objectAtIndex:i]])]){
            NSLog(@"%@",[[commandListV2 objectAtIndex:0] objectAtIndex:i]);
            
            [monchat addObject:command];
            [self.tableView reloadData];
            
            NSString *response  = [NSString stringWithFormat:@"{\"action\":\"CATCH_COMMAND\",\"command\":\"%@\",\"confidence\":0.9,\"text\":\"\"}<EOF>",[[commandListV2 objectAtIndex:0] objectAtIndex:i]];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
            [outputStream write:[data bytes] maxLength:[data length]];
            
            NSLog(@"Message send : %@",response);
            
            
        }
    }

    
    
}

- (void)initSocketCommunication {
    
    uint portNo = 9999;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)savedServer, portNo, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
}

-(void)startClientListen{
    
    NSString *response  = [NSString stringWithFormat:@"{\"action\":\"CLIENT_INFOS\",\"version\":\"2\",\"type\":\"listen\",\"location\":\"mobile\",\"token\":\"%@\"}<EOF>",savedToken];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}

-(void)startClientSpeaker{
    
    NSString *response  = [NSString stringWithFormat:@"{\"action\":\"CLIENT_INFOS\",\"version\":\"2\",\"type\":\"speak\",\"location\":\"mobile\",\"token\":\"%@\"}<EOF>",savedToken];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    uint8_t buffer[1024];
    NSUInteger len;
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            if (theStream == inputStream) {
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);

                            
                            NSData *jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
                            NSError *error;
                            NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                            
                            
                            if (jsonObjects != NULL)
                            {
                                NSString *action = [jsonObjects objectForKey:@"action"];
                                NSLog(@"action: %@", action);
                                if([action isEqualToString:@"talk"]){
                                    NSString *message = [jsonObjects objectForKey:@"message"];
                                    NSLog(@"message: %@",message);
                                    
                                    [monchat addObject:message];
                                    [self.tableView reloadData];
                                }
                                else if([[jsonObjects objectForKey:@"action"]isEqualToString:(@"sound")]){
                                    
                                    NSString *file = [jsonObjects objectForKey:@"file"];
                                    
                                    NSString* son = [[file lastPathComponent] stringByDeletingPathExtension];
                                    NSLog(@"son : %@",son);
                                    
                                    NSURL *sonURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:son ofType:@"wav"]];
                                    AudioServicesCreateSystemSoundID((__bridge CFURLRef) sonURL, &SoundId );
                                    AudioServicesPlaySystemSound(SoundId);
                                    
                                    
                                }
                            }
                            
                        }
                    }
                }
            } else {
                NSLog(@"it is NOT theStream == inputStream");
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host! %lu",(unsigned long)streamEvent);
            break;
            
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
            
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
    
}
@end