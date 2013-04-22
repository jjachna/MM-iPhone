//
//  MMSecondViewController.m
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import "MMHighScoreViewController.h"

@interface MMHighScoreViewController ()

@end

@implementation MMHighScoreViewController

-(id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [highScores setString:[ud stringForKey:@"highScores"]];
    
    //NSURLRequest for high scores.
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:highScores forKey:@"highScores"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
