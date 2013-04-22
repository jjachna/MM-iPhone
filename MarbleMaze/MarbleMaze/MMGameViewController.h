//
//  MMFirstViewController.h
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMGameViewController : UIViewController <NSURLConnectionDelegate, NSXMLParserDelegate>
{
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    
    IBOutlet UIImageView *redBall;
    IBOutlet UIImageView *connStatus;
    IBOutlet UIActivityIndicatorView *spinner;
    
    BOOL isConnected;
    
    NSURLConnection *urlConnection;
    NSMutableData *xmlData;
    NSString *CURRENT_SERVER;
    
    UISwipeGestureRecognizer *swipe;
}

@end
