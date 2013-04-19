//
//  MMFirstViewController.m
//  MarbleMaze
//
//  Created by John Jachna on 4/19/13.
//  Copyright (c) 2013 John Jachna. All rights reserved.
//

#import "MMGameViewController.h"
#import <CoreMotion/CoreMotion.h>

#define X_ORG 215
#define Y_ORG 135

@interface MMGameViewController ()
@property (strong,nonatomic) CMMotionManager *manager;
@end


@implementation MMGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    xmlData = [[NSMutableData alloc] init];
    isConnected = NO;
    
    CURRENT_SERVER = @"192.168.2.1"; // Raspberry Pi AP IP
    //    CURRENT_SERVER = @"192.168.2.11"; // Local Network
    
    NSString *str = [NSString stringWithFormat:@"http://%@/connect", CURRENT_SERVER];
    NSLog(@"%@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    [spinner startAnimating];
    
    
    self.manager = [[CMMotionManager alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
    
    self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.manager startDeviceMotionUpdates];
    
    
}

-(void) getValues:(NSTimer *) timer
{
    xLabel.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.manager.deviceMotion.attitude.pitch];
    yLabel.text = [NSString stringWithFormat:@"%.2f", ((180/M_PI)*self.manager.deviceMotion.attitude.roll)];
    zLabel.text = [NSString stringWithFormat:@"%.2f",(-180/M_PI)*self.manager.deviceMotion.attitude.yaw];
    
    if (isConnected)
    {
        NSString *str = [NSString stringWithFormat:@"http://%@/position/x=%@_y=%@", CURRENT_SERVER, xLabel.text, yLabel.text];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    }
    
    redBall.transform = CGAffineTransformMakeTranslation(2.5*(180/M_PI)*self.manager.deviceMotion.attitude.pitch, -1.5*(180/M_PI)*self.manager.deviceMotion.attitude.roll);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connection data: %@", xmlData);
    
    isConnected = YES;
    connStatus.image = [UIImage imageNamed: @"conn.png"];
    [spinner stopAnimating];
    
    //    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    //    xmlParser.delegate = self;
    //    [xmlParser parse];
    
    
    
    xmlData = nil;
    urlConnection = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    isConnected = NO;
    connStatus.image = [UIImage imageNamed: @"unconn.png"];
    NSLog(@"error: %@", error);
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"parsing time");
    if ([elementName isEqualToString:@"request"])
    {
        
    }
    
}


@end
