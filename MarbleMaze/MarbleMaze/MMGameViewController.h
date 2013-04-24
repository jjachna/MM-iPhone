//
//  MMGameViewController.h
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MMGameViewController : UIViewController <NSURLConnectionDelegate, NSXMLParserDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate>
{
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    
    IBOutlet UIImageView *redBall;
    IBOutlet UIButton *connStatus;
    IBOutlet UIActivityIndicatorView *spinner;
    
    BOOL isConnected;
    BOOL gameRunning;
    
    NSURLConnection *urlConnection;
    NSMutableData *xmlData;
    NSMutableString *CURRENT_SERVER;
    AVAudioPlayer* connectPlayer;
    AVAudioPlayer* beginPlayer;
    AVAudioPlayer* endPlayer;
    
    IBOutlet UILabel *timeLabel;
    UIAlertView *message;
    NSTimeInterval currentTime;
    NSDate *startTime;
}

-(IBAction) reconnectToServer:(id)sender;

@end
