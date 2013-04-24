//
//  MMFirstViewController.h
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMGameViewController : UIViewController <NSURLConnectionDelegate, NSXMLParserDelegate, UIAlertViewDelegate>
{
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    
    IBOutlet UIImageView *redBall;
    IBOutlet UIButton *connStatus;
    IBOutlet UIActivityIndicatorView *spinner;
    
    BOOL isConnected;
    
    NSURLConnection *urlConnection;
    NSMutableData *xmlData;
    NSMutableString *CURRENT_SERVER;
    
    UIAlertView *message;
}

-(IBAction) reconnectToServer:(id)sender;

@end
