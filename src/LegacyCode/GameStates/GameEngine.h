#ifndef GamePrototype_GameEngine
#define GamePrototype_GameEngine

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxiPhoneExternalDisplay.h"

//ON IPHONE NOTE INCLUDE THIS BEFORE ANYTHING ELSE
#include "ofxOpenCv.h"

#include <iostream>
#include <fstream>
#include <list>

// Scene Manager Includes
#include "ofxAnimatableFloat.h"
#include "ofxSceneManager.h"
#include "ofxUI.h"
#include "Expressions.h"

// GameStates

#include "GameIntro.h"
#include "GameOutro.h"
#include "GameMenu.h"
#include "GamePlay.h"
#include "GamePlayMenu.h"
#include "GameAbout.h"
#include "GameWeb.h"

#include "Globals.h"


@protocol GameAppDelegate <NSObject>
@optional
- (void)gameStarted;
- (void)gameFinished;
- (void)gameExit;
@end

enum GameType {
	GAMETYPE_PLAY,
	GAMETYPE_PRACTICE,
	GAMETYPE_DEBUG,
	GAMETYPE_EVENT
};


//#define USE_CAMERA

class GameEngine : public ofxiPhoneApp, public ofxiPhoneExternalDisplay {
	
	public:
		
		GameEngine();
		void setup();
		void update();
		void draw();
        void exit();
		
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
    
		// Scene Manager Enum
		enum Scenes {
			INTRO = 1,
			MENU,
			GAME_PLAY,
			GAME_PLAY_MENU,
			SETTINGS,
			ABOUT,
			SURVEY,
			TUTORIAL,
			REVIEW,
			UPLOAD,
			OUTRO
		};
	
		ofxSceneManager* sceneManager;
		//Expressions* expressions;
	
		void playClick();
		void setDifficulty(int difficulty);
	
	
		ofSoundPlayer* clickPlayer;
	
		id delegate;
	
	GameIntro * intro;
	GameOutro * outro;
	GamePlay * play;
    
private:
	// variables
    
};

#endif
