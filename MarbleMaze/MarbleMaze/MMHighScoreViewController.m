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

@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    highScores = [[NSMutableString alloc] initWithString:@"initialized"];
    highScoreArray = [[NSMutableArray alloc] init];
    
    CGRect horizFrame = CGRectMake(0, 0, 480, 300);
    self.tableView = [[UITableView alloc] initWithFrame:horizFrame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [highScores setString:[ud stringForKey:@"highScores"]];
    
    //NSURLRequest for high scores.
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    CURRENT_SERVER = [[NSMutableString alloc] init];
    CURRENT_SERVER = [rootDict objectForKey:@"SERVER"];
    
    if ([ud boolForKey:@"isConnected"] == YES)
    {
        NSLog(@"Connected to server");
        NSString *str = [NSString stringWithFormat:@"http://%@/getHighScore", CURRENT_SERVER];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSString *responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if ((responseBody != nil) && (responseBody.length > 0))
        {
            NSLog(@"Load from Server");
            [ud setObject:responseBody forKey:@"highScores"];
            NSArray *tempArray = [responseBody componentsSeparatedByString: @","];
            for (NSString *item in tempArray)
            {
                [highScoreArray addObject:item];
            }
        }
        else
        {
            NSLog(@"No Response, load from User Defaults");
            NSArray *tempArray = [highScores componentsSeparatedByString: @","];
            for (NSString *item in tempArray)
            {
                [highScoreArray addObject:item];
            }
        }
    }
    else
    {
        NSLog(@"Not connected to server, load from User Defaults");
        NSArray *tempArray = [highScores componentsSeparatedByString: @","];
        for (NSString *item in tempArray)
        {
            [highScoreArray addObject:item];
        }
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return highScoreArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProductCellIdentifier = @"ProductCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ProductCellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%dst Fastest Time", indexPath.row + 1];
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%dnd Fastest Time", indexPath.row + 1];
            break;
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%drd Fastest Time", indexPath.row + 1];
            break;
        default:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%dth Fastest Time", indexPath.row + 1];
            break;
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ seconds", [highScoreArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
