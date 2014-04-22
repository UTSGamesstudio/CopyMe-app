//
//  GameEngineViewController.m
//  CopyMe
//
//  Created by Daniel Rosser on 28/10/2013.
//
//

#import "GameEngineViewController.h"

#import "GamePlayEngine.h"
//#import "TestFlight.h"
#import "ofxiOSExtras.h"
#import "ofxiOSEAGLView.h"
#import "PlayUIView.h"
#import "AppDelegate.h"

@interface GameEngineViewController () <GameAppDelegate> {
	GamePlayEngine * app;
	IBOutlet UIView * appContainer;
	int difficultyLevel;
}
@property(nonatomic, retain) ofxiOSEAGLView * glView;
@property(nonatomic, retain) PlayUIView * playUIView;

@end

@implementation GameEngineViewController

//@synthesize  glView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		difficultyLevel = 0;
    }
    return self;
}

- (void)dealloc {
    
    if(app) {
		app->setDelegate(nil);
	}
    
	[appContainer release];
	appContainer = nil;
	
	if(self.playUIView) {
		[self.playUIView clearDelegate];
		[self.playUIView removeFromSuperview];
		self.playUIView = nil;
	}
    
    [self destroyGLView];
    [self removeGLView];
	
	self.glView = nil;
    
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createGLView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[TestFlight passCheckpoint:@"Game_Play"];
	
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate removeBackground];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.glView) {
        [self.glView startAnimation];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.glView) {
        [self.glView stopAnimation];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)createGLView {
	
	if(self.playUIView) {
		[self.playUIView removeFromSuperview];
		self.playUIView = nil;
	}
	self.playUIView = [[[NSBundle mainBundle] loadNibNamed:@"PlayUIView" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:self.playUIView];
	[self.playUIView setDelegate:self];
	[self.playUIView loadImages];
	
	if(self.glView != nil) {
        return NO;
    }
    app = new GamePlayEngine();
    app->setDelegate(self);
	
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
	
    self.glView = [[[ofxiOSEAGLView alloc] initWithFrame:rect andApp:app] autorelease];
    self.glView.delegate = self;
    self.glView.multipleTouchEnabled = NO;
	self.glView.backgroundColor = [UIColor clearColor];
	self.glView.opaque = NO;
    [appContainer insertSubview:self.glView atIndex:0];
    [self.glView layoutSubviews];
    [self.glView setup];
    [self.glView startAnimation];
	
	
	[self setDifficulty:difficultyLevel];
	
    return YES;
}

- (BOOL)destroyGLView {
	
	if(self.playUIView) {
		[self.playUIView removeImages];
		[self.playUIView clearDelegate];
		[self.playUIView removeFromSuperview];
		self.playUIView = nil;
	}
    
    app->clearDelegate();
	
    if(self.glView == nil) {
        return NO;
    }
    
    [self.glView stopAnimation];
    self.glView.delegate = nil;
    [self.glView destroy];
    
    
    return YES;
}

- (BOOL)removeGLView {
    if(self.glView == nil) {
        return NO;
    }
	
    [self.glView removeFromSuperview];
    self.glView = nil;

    
    return YES;
}

- (void)glViewDraw {
    [self timerLoop];
}

- (void)timerLoop {
    // to be extended.
}


- (void)gameStarted {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate hideSplashImage];
	[self.playUIView setClickReady:YES];
}

- (void)gameLoaded {
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//	[appDelegate hideSplashImage];
	app->setiOSReady(true);
	
}

- (void)gameExit {
	AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate loadBackground];
	[self popHome];
}

- (void)scoreChanged {
	int score = app->getScore();
	[self.playUIView setScore:score];
}

- (void) setDifficulty:(int)difficulty {
	difficultyLevel = difficulty;
	if(app){
		app->setDifficulty(difficulty);
	}
}

- (void) appHomeButtonPressed {
	[self gameExit];
}
- (void) appNextButtonPressed {
	app->nextFaceButtonPressed();
}
- (void) appMusicOnButtonPressed {
	app->musicOnButtonPressed();
}
- (void) appMusicOffButtonPressed {
	app->musicOffButtonPressed();
}
- (void) appSoundOnButtonPressed {
	app->soundOnButtonPressed();
}
- (void) appSoundOffButtonPressed {
	app->soundOffButtonPressed();
}
- (void) appHelpButtonPressed {
	app->helpButtonPressed();
}

@end
