//
//  GamePlayEngine.h
//  CopyMe

#ifndef __CopyMe__GamePlayEngine__
#define __CopyMe__GamePlayEngine__

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxiOSExternalDisplay.h"

//ON IPHONE NOTE INCLUDE THIS BEFORE ANYTHING ELSE
#include "ofxOpenCv.h"

#include <iostream>
#include <fstream>
#include <list>

// Scene Manager Includes
#include "ofxAnimatableFloat.h"
#include "Expressions.h"

#include "Expressions.h"
#include "Globals.h"
#include "GameStats.h"
#include "ofxThreadedImageLoader.h"


//#define EXPRESSION_SAVE
//#undef EXPRESSION_SAVE

#import <SoundEngine.h>

// class for emotion descriptor in speech bubble

#include "DescriptionImage.h"

// class for voice guide

#include "NarrationSound.h"

// class for each face photo

#include "FaceImage.h"

// class for managing face photos

#include "FaceImageManager.h"

#include "GameSoundManager.h"
#include "ofxiOSSoundPlayer.h"

@protocol GameAppDelegate <NSObject>
@optional
- (void) gameLoaded;
- (void) gameStarted;
- (void) gameFinished;
- (void) scoreChanged;
- (void) gameExit;
- (void) appHomeButtonPressed;
- (void) appNextButtonPressed;
- (void) appMusicOnButtonPressed;
- (void) appMusicOffButtonPressed;
- (void) appSoundOnButtonPressed;
- (void) appSoundOffButtonPressed;
- (void) appHelpButtonPressed;
@end

enum GameType {
	GAMETYPE_PLAY,
	GAMETYPE_PRACTICE,
	GAMETYPE_DEBUG,
	GAMETYPE_EVENT
};


class GamePlayEngine : public ofxiOSApp {
public:
    
    GamePlayEngine();
    ~GamePlayEngine();
	void setup();
	void setupGame();
	
	void update();
	void updateGame(float dt);
	
	void draw();
	void drawGame();
	
	void exit();
	void exitGame();
	
	void touchDown(ofTouchEventArgs & touch);
	void touchMoved(ofTouchEventArgs & touch);
	void touchUp(ofTouchEventArgs & touch);
	void touchDoubleTap(ofTouchEventArgs & touch);
	void touchCancelled(ofTouchEventArgs & touch);
	
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
	
	void setDelegate(id delegate);
	void clearDelegate();
	
	// obj-c var
	id delegate;

	
	void load();
	void unload();
    
	bool hasLoaded();
	
	void playClick();
	void setDifficulty(int difficulty);
	
	
	// App Control
	void helpButtonPressed();
	void soundOnButtonPressed();
	void soundOffButtonPressed();
	void musicOnButtonPressed();
	void musicOffButtonPressed();
	void nextFaceButtonPressed();
	void setiOSReady(bool value);
	int getScore();
	
	
private:
    
	FaceImages* faces;
	
	enum LevelState {
		loading = 0,
		intro,
		noFace,
		promptFace,
		foundFace,
		correctFace,
		skippedFace,
		incorrectSkippedFace,
		incorrectFace,
		helpScreen,
		endgame,
		iosReady
	};
	
	
	
	
	
	float totalIntro;
	float totalNoFace;
	float totalPromptFace;
	float minFoundFace;
	float totalFoundFace;
	float totalCorrectFace;
	float totalIncorrectFace;
	float totalHelpScreen;
	float totalSkippedFace;
	
	float expressionTimer;
	float totalExpressionTimer;
	
	float step;
	bool soundOn;
	bool musicOn;
	bool helpOn;
	
    LevelState levelState;
	
	ofImage* wellDone;
	ofImage* background;

	ofImage* tryAgainImage;
	ofImage* tickImage;
	ofImage* cantSeeImage2;
	string backgroundName;
	string wellDoneName;
	//string helpImageName;
	string tryAgainName;
	string tickName;
	string cantSeeName2;

	GameStats*				  gameStats;
	
	int incorrect;
	int correct;
	
	Expressions* expressions;
	ofxThreadedImageLoader* loader;
	
	bool isiOSReady;
	
};



#endif /* defined(__CopyMe__GamePlayEngine__) */
