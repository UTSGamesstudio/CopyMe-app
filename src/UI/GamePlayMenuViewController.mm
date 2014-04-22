//
//  GamePlayMenuViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 29/10/2013.
//
//

#import "GamePlayMenuViewController.h"

#import "GameEngineViewController.h"

//#import "TestFlight.h"
#import "UIImage+TPAdditions.h"

#import "AppDelegate.h"


@interface GamePlayMenuViewController () {
	IBOutlet UIImageView * basicText;
	IBOutlet UIImageView * mediumText;
	IBOutlet UIImageView * hardText;
	IBOutlet UIButton * basicButton;
	IBOutlet UIButton * mediumButton;
	IBOutlet UIButton * hardButton;
	IBOutlet UIButton * homeButton;
	IBOutlet UIImageView * buttonBackground;
}

@end

@implementation GamePlayMenuViewController

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
    
	[basicText release];
    basicText = nil;
	[mediumText release];
    mediumText = nil;
	[hardText release];
    hardText = nil;
	
	[basicButton release];
    basicButton = nil;
	[mediumButton release];
    mediumButton = nil;
	[hardButton release];
    hardButton = nil;
	
	[homeButton release];
    homeButton = nil;
	
	[super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadImages];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self removeImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[TestFlight passCheckpoint:@"Play_Menu"];
}

- (IBAction)basicPlayButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		//[appDelegate showSplashImage];
		[UIView animateWithDuration:0.7 animations:^{
			[appDelegate showSplashImage];
		} completion:^(BOOL finished) {
			[self setTransition];
			NSLog(@"Basic Button Pressed");
			GameEngineViewController * viewController = [[[GameEngineViewController alloc] init] autorelease];
			[viewController setDifficulty:0];
			[self.navigationController pushViewController:viewController animated:NO];
			
		}];}
}

- (IBAction)mediumPlayButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		
		[UIView animateWithDuration:0.4 animations:^{
			[appDelegate showSplashImage];
		} completion:^(BOOL finished) {
			[self setTransition];
			NSLog(@"Medium Button Pressed");
			GameEngineViewController * viewController = [[[GameEngineViewController alloc] init] autorelease];
			[viewController setDifficulty:1];
			[self.navigationController pushViewController:viewController animated:NO];
			
		}];}
}


- (IBAction)hardPlayButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		
		AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		
		
		[UIView animateWithDuration:0.4 animations:^{
			[appDelegate showSplashImage];
		 } completion:^(BOOL finished) {
			 [self setTransition];
			 NSLog(@"Hard Button Pressed");
			 GameEngineViewController * viewController = [[[GameEngineViewController alloc] init] autorelease];
			 [viewController setDifficulty:2];
			 [self.navigationController pushViewController:viewController animated:NO];

		 }];
		
	}
}

- (void) loadImages {
	
	buttonBackground.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/bottomBar.png"];
	
	basicText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_basicText.png"];
	mediumText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_mediumText.png"];
	hardText.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_hardText.png"];
	
	[basicButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_easyButton.png"] forState:UIControlStateNormal];
	[mediumButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_mediumButton.png"] forState:UIControlStateNormal];
	[hardButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/diff_hardButton.png"] forState:UIControlStateNormal];
	
	[homeButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/homeButton.png"] forState:UIControlStateNormal];
	
}
- (void) removeImages {
	buttonBackground.image = nil;
    
	basicText.image = nil;
	mediumText.image = nil;
	hardText.image = nil;
	
	[basicButton setImage:nil forState:UIControlStateNormal];
	[mediumButton setImage:nil forState:UIControlStateNormal];
	[hardButton setImage:nil forState:UIControlStateNormal];
    
	[homeButton setImage:nil forState:UIControlStateNormal];
}


@end
