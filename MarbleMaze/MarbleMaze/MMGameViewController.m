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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"isConnected"];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    CURRENT_SERVER = [[NSMutableString alloc] init];
    CURRENT_SERVER = [rootDict objectForKey:@"SERVER"];
    NSLog(@"%@", CURRENT_SERVER);
    //CURRENT_SERVER = @"192.168.2.1"; // Raspberry Pi AP IP
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
    
    if(!connectPlayer){
        /*
         * Here we grab our path to our resource
         */
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        resourcePath = [resourcePath stringByAppendingString:@"/connect.aif"];
        NSError* err;
        
        //Initialize our player pointing to the path to our resource
        connectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:&err];
        connectPlayer.delegate = self;
        connectPlayer.numberOfLoops = 0;
    }
    
    if(!beginPlayer){
        /*
         * Here we grab our path to our resource
         */
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        resourcePath = [resourcePath stringByAppendingString:@"/begin.wav"];
        NSError* err;
        
        //Initialize our player pointing to the path to our resource
        beginPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:&err];
        beginPlayer.delegate = self;
        beginPlayer.numberOfLoops = 0;
    }
    
    if(!endPlayer){
        /*
         * Here we grab our path to our resource
         */
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        resourcePath = [resourcePath stringByAppendingString:@"/win.wav"];
        NSError* err;
        
        //Initialize our player pointing to the path to our resource
        endPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:&err];
        endPlayer.delegate = self;
        endPlayer.numberOfLoops = 0;
    }

}

-(void) getValues:(NSTimer *) timer
{
    xLabel.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.manager.deviceMotion.attitude.pitch];
    yLabel.text = [NSString stringWithFormat:@"%.2f", ((180/M_PI)*self.manager.deviceMotion.attitude.roll)];
    
    if (isConnected)
    {
        NSString *str = [NSString stringWithFormat:@"http://%@/position/x=%@_y=%@", CURRENT_SERVER, xLabel.text, yLabel.text];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    }
    
    redBall.transform = CGAffineTransformMakeTranslation(2.5*(180/M_PI)*self.manager.deviceMotion.attitude.pitch, -2.5*(180/M_PI)*self.manager.deviceMotion.attitude.roll);
}

- (void)reconnectToServer:(id)sender
{
    [connectPlayer play];
    NSString *str = [NSString stringWithFormat:@"http://%@/connect", CURRENT_SERVER];
    NSLog(@"%@", str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    [spinner startAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    isConnected = YES;
    connStatus.imageView.image = [UIImage imageNamed: @"conn.png"];
    [spinner stopAnimating];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isConnected"];
    
    xmlData = nil;
    urlConnection = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    isConnected = NO;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"isConnected"];
    
    connStatus.imageView.image = [UIImage imageNamed: @"unconn.png"];
    NSLog(@"error: %@", error);
    [spinner stopAnimating];
    
    message = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"The app is currently not connected to the Marble Maze.  Tap the connection status button to reconnect." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [message show];
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
