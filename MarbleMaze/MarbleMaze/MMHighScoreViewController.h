//
//  MMHighScoreViewController.h
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHighScoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableString *highScores;
    NSMutableArray *highScoreArray;
    NSMutableString* CURRENT_SERVER;
}
@property (nonatomic, strong) UITableView *tableView;

@end
