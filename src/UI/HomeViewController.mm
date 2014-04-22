//
//  HomeViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 24/09/13.
//  Copyright (c) 2013 Daniel Rosser. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVSoundPlayer.h"
#import "UIImage+TPAdditions.h"

#import "SurveyViewController.h"

#import "HomeViewController.h"
#import "AboutViewController.h"
#import "GameEngineViewController.h"
#import "GamePlayMenuViewController.h"

#import "AppDelegate.h"
#import "AppGlobals.h"

//#import "TestFlight.h"



@interface HomeViewController () <UIAlertViewDelegate> {
	IBOutlet UIImageView * backgroundLogo;
	IBOutlet UIButton * playButton;
	IBOutlet UIButton * aboutButton;
	IBOutlet UIButton * surveyButton;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    return self;
}

-(id)init {
	self = [super init];
	if(self) {
		[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self setModalPresentationStyle:UIModalPresentationCurrentContext];
		[self shouldFade:YES];
	}
	return self;
}

- (void)dealloc {
	[self removeImages];
	
	[backgroundLogo release];
	backgroundLogo = nil;
	[playButton release];
	playButton = nil;
	[aboutButton release];
	aboutButton = nil;
	[surveyButton release];
	surveyButton = nil;
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadImages];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[TestFlight passCheckpoint:@"Main_Menu"];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self removeImages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self setModalPresentationStyle:UIModalPresentationCurrentContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playButtonPressed:(id)sender {
	
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		NSLog(@"Play Button Pressed");
		[self setTransition];
		GamePlayMenuViewController * viewController = [[[GamePlayMenuViewController alloc] init] autorelease];
		[self.navigationController pushViewController:viewController animated:NO];
	}
}

- (IBAction)surveyButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		NSLog(@"Survey Button Pressed");
		[self setTransition];
		SurveyViewController * viewController = [[[SurveyViewController alloc] init] autorelease];
		[self.navigationController pushViewController:viewController animated:NO];
	}
}


- (IBAction)aboutButtonPressed:(id)sender {
	if([self isClickReady]) {
		[self setClickReady:NO];
		[self playClick];
		NSLog(@"About Button Pressed");
		[self setTransition];
		AboutViewController * viewController = [[[AboutViewController alloc] init] autorelease];
		[self.navigationController pushViewController:viewController animated:NO];
	}
}

- (void) loadImages {
	backgroundLogo.image = [UIImage imageWithContentsOfResolutionIndependentFile:@"images/ui_logo.png"];
	[playButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/main_playButton.png"] forState:UIControlStateNormal];
	[aboutButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/main_aboutButton.png"] forState:UIControlStateNormal];
	[surveyButton setImage:[UIImage imageWithContentsOfResolutionIndependentFile:@"images/main_surveyButton.png"] forState:UIControlStateNormal];
	
}
- (void) removeImages {
	backgroundLogo.image = nil;
	[playButton setImage:nil forState:UIControlStateNormal];
	[aboutButton setImage:nil forState:UIControlStateNormal];
	[surveyButton setImage:nil forState:UIControlStateNormal];
}

@end
