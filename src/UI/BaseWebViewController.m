//
//  BaseWebViewController.m
//
//  Created by Daniel Rosser on 18/09/13.
//
//

#import "BaseWebViewController.h"

// globals
#import "AppGlobals.h"

@interface BaseWebViewController ()<UIWebViewDelegate> {
	IBOutlet UIWebView * webView;
	IBOutlet UIView * cover;
	IBOutlet UIView * failedCover;
    IBOutlet UIActivityIndicatorView * spinner;
    BOOL bLoaded;
}
@end

@implementation BaseWebViewController

- (void)dealloc {
    [cover release];
	cover = nil;
	if(spinner) {
		[spinner stopAnimating];
		[spinner release];
	}
	spinner = nil;
	if(webView) {
		if(webView.delegate) {
			webView.delegate = nil;
		}
		[webView release];
	}
	webView = nil;

	[failedCover release];
	failedCover = nil;

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        bLoaded = NO;
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	cover.hidden = YES;
    spinner.hidden = YES;
	
	failedCover.hidden = YES;
	
	
	webView.delegate = self;
	[webView setBackgroundColor:[UIColor clearColor]];
	[webView setOpaque:NO];
	
}

- (void)loadWebURL:(NSString *)address {
	NSString *urlAddress = @"";
	urlAddress = [NSString stringWithFormat:@"%@%@", kWebsiteURL, address];
	
	 //RETINA CODE
//		NSString *retina = @"?retina=1";
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
//			([UIScreen mainScreen].scale == 2.0)) {
//			// Retina display
//			urlAddress = [NSString stringWithFormat:@"%@%@", urlAddress, retina];
//		} else {
//			retina = @"";
//		}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
	// Get rid of the shadow on the top and bottom of the webview
	for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
		if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
	}
}

- (void)loadCustomWebURL:(NSString *)address {
	NSString *urlAddress = @"";
	urlAddress = [NSString stringWithFormat:@"%@", address];
	
	// RETINA CODE
//		NSString *retina = @"?retina=1";
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
//			([UIScreen mainScreen].scale == 2.0)) {
//			// Retina display
//			urlAddress = [NSString stringWithFormat:@"%@%@", urlAddress, retina];
//		} else {
//			retina = @"";
//		}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
	// Get rid of the shadow on the top and bottom of the webview
	for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
		if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
	}
}


//------------------------------------------------------------------ cover.
- (void)showCover {
    cover.hidden = NO;
    cover.alpha = 0.0;
    spinner.hidden = NO;
    spinner.alpha = 0.0;
	
	[spinner startAnimating];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
        cover.alpha = 1.0;
        spinner.alpha = 1.0;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideCover {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
        cover.alpha = 0.0;
        spinner.alpha = 0.0;
		
    } completion:^(BOOL finished) {
		[spinner stopAnimating];
        cover.hidden = YES;
        spinner.hidden = YES;
    }];
}


- (void)showFailedCover {
    failedCover.hidden = NO;
    failedCover.alpha = 0.0;
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
        failedCover.alpha = 1.0;
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideFailedCover {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
		failedCover.alpha = 0.0;
		
    } completion:^(BOOL finished) {
        failedCover.hidden = YES;
    }];
}


-(void)webViewDidStartLoad:(UIWebView *)aWebView {
	[self hideFailedCover];
	[self showCover];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	
	[aWebView setBackgroundColor:[UIColor clearColor]];
	[aWebView setOpaque:NO];
	
//	CGRect frame = aWebView.frame;
//	frame.size.height = 1;
//	aWebView.frame = frame;
//	CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//	frame.size = fittingSize;
//	aWebView.frame = frame;
	[self hideCover];
	[self hideFailedCover];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	[self hideCover];
	[self showFailedCover];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSString *detail = @"";
	switch (error.code) {
		case BrowserErrorHostNotFound:
			//
			detail = @"Can't connect to the server. \n\nPlease make sure you are connected to the internet and try again at a later time.";
			break;
		case BrowserErrorOperationNotCompleted:
			//
			detail = @"Timed out connecting. \n\nPlease make sure you are connected to the internet and try again.";
			break;
		case BrowserErrorNoInternetConnection:
			//
			detail = @"No internet connection. \n\nPlease make sure you are connected to the internet and try again.";
			break;
		default:
			// unknown
			break;
	}
	
	UIAlertView * alertView;
    alertView = [[[UIAlertView alloc] initWithTitle:@"Loading Error"
                                            message:detail
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] autorelease];
    [alertView show];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
