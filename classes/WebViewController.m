//
//  WebViewController.m
//  BBB
//
//  Created by Jie Zhao on 5/22/11.
//  Copyright 2011 Zeiga. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView, activityIndicator, stringURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.webView.delegate = nil;
    [self.webView release];
    [self.activityIndicator release]; 
    [super dealloc];
}

#pragma mark - View lifecycle

-(void)loadView {
    UIView *contentView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view = contentView;	
    
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y = 0.0f;
	self.webView = [[UIWebView alloc] initWithFrame:webFrame];
	self.webView.backgroundColor = [UIColor blueColor];
	self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.webView.delegate = self;
	[self.view addSubview: self.webView];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.stringURL]]];
    
	self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicator.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
	self.activityIndicator.center = self.view.center;
	[self.view addSubview: self.activityIndicator];
}

- (void)viewDidLoad
{	
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.webView stopLoading];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark WEBVIEW Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><br /><br /><font size=+5 color='red'>Error<br /><br />Your request %@</font></center></html>",
							 error.localizedDescription];
	[self.webView loadHTMLString:errorString baseURL:nil];
}

@end
