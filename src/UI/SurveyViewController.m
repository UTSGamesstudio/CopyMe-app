//
//  SurveyViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 27/09/13.
//
//

#import "SurveyViewController.h"
#import "AppGlobals.h"

//#import "TestFlight.h"

#import "UIImage+TPAdditions.h"

@interface SurveyViewController () <UIAlertViewDelegate> {
	IBOutlet UIButton * homeButton;
//	IBOutlet UIButton * privacyButton;
//	IBOutlet UIButton * termsButton;
//	IBOutlet UIButton * helpButton;
	IBOutlet UIImageView * titleText;
	IBOutlet UIImageView * buttonBackground;
	IBOutlet UIImageView * loadingLogo;
	IBOutlet UIImageView * loadingText;
	IBOutlet UIImageView * failedText;
}
@end

@implementation SurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [self removeImages];
    
	[titleText release];
    titleText = nil;
//	[privacyButton release];
//	[termsButton release];
	[buttonBackground release];
    buttonBackground = nil;
	[homeButton release];
    homeButton = nil;
	[loadingLogo release];
    loadingLogo = nil;
	[loadingText release];
    loadingText = nil;
	[failedText release];
    failedText = nil;
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
//	[self loadCustomWebURL:kWebsiteSurvey];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[TestFlight passCheckpoint:@"Survey"];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	
	UIAlertView * alertView;
//	alertView = [[[UIAlertView alloc] initWithTitle:@"Access Survey"
//											message:@"You need permission from a \n parent/guardian to access the \n online survey if you are \n under 13 years of age. \n\n Access the online survey?"
//										   delegate:self
//								  cancelButtonTitle:@"No"
//								  otherButtonTitles:@"Yes", nil] autorelease];
	
	alertView = [[[UIAlertView alloc] initWithTitle:@"Confirm Age"
											message:@"Are you over 13 years old?"
										   delegate:self
								  cancelButtonTitle:@"No"
								  otherButtonTitles:@"Yes", nil] autorelease];
	[alertView show];
	
//[TestFlight submitFeedback:feedback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
//	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[self loadImages];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self removeImages];
}

- (void) loadImages {
	buttonBackground.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/bottomBar.png"];
	titleText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/surveyTitle.png"];
	loadingText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/loading.png"];
	failedText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/survey_loadFailed.png"];
	loadingLogo.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/loading_logo.png"];
	[homeButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/homeButton.png"] forState:UIControlStateNormal];
//	[termsButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/tandcsButton.png"] forState:UIControlStateNormal];
//	[privacyButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/privacyButton.png"] forState:UIControlStateNormal];
//
//	[helpButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/helpButton.png"] forState:UIControlStateNormal];
	
}
- (void) removeImages {
	failedText.image = nil;
	titleText.image = nil;
	loadingText.image = nil;
	loadingLogo.image = nil;
	buttonBackground.image = nil;
	[homeButton setImage:nil forState:UIControlStateNormal];
//	[termsButton setImage:nil forState:UIControlStateNormal];
//	[privacyButton setImage:nil forState:UIControlStateNormal];
//	[helpButton setImage:nil forState:UIControlStateNormal];
}

- (IBAction)termsButtonPressed:(id)sender {
	[self playClick];
	NSLog(@"TermsButtonPressed");
	[self loadCustomWebURL:kWebsiteTerms];
}

- (IBAction)privacyButtonPressed:(id)sender {
	[self playClick];
	NSLog(@"privacyButtonPressed");
	[self loadCustomWebURL:kWebsitePrivacy];
}

- (IBAction)helpButtonPressed:(id)sender {
	[self playClick];
	NSLog(@"helpButtonPressed");
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSString * title = [actionSheet title];
		if (buttonIndex == 1) {
			NSLog(@"YES");
			[self loadCustomWebURL:kWebsiteSurvey];
			return;
		}
		else if (buttonIndex == 0) {
			NSLog(@"NO");
			[self showFailedCover];
			return;
		}
		else {
			NSLog(@"ELSE");
		}
	
}


@end
