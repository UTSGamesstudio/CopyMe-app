#ifndef GamePrototype_GamePlay_h
#define GamePrototype_GamePlay_h

#include "ofMain.h"
#include "ofxScene.h"

#include "ofxSceneManager.h"
#include "ofxUI.h"
#include "Expressions.h"
#include "ofxSpriteSheetRenderer.h"
#include "Sprites.h"
#include "GameStats.h"
#include "ofxThreadedImageLoader.h"
#include "UISelfManagedImageButton.h"




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

class GamePlay : public ofxScene{
	
	
	void setup();
	void update(float dt);
	void draw();
    void exit();
	
	void load();
	void unload();
	void unloadGUI();
    
    
	void sceneWillAppear( ofxScene * fromScreen );
	void sceneWillDisappear( ofxScene * toScreen );
    void sceneDidAppear();
    void sceneDidDisappear( ofxScene * fromScreen );
  
    
	void setGUI();
    
    //--------------------------------------------------------------
    void guiEvent(ofxUIEventArgs &e);
    
	bool hasLoaded();
	
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
					  endgame
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
	ofImage* helpImage;
	ofImage* tryAgainImage;
	ofImage* tickImage;
	ofImage* cantSeeImage2;
	string backgroundName;
	string wellDoneName;
	string helpImageName;
	string tryAgainName;
	string tickName;
	string cantSeeName2;
	
	GameStats*				  gameStats;
    ofSoundPlayer             soundPlayer;
	ofSoundPlayer             successPlayer;
	ofSoundPlayer*            clickPlayer;
	ofSoundPlayer             wrongPlayer;
	
	ofSoundPlayer             nIncorrectPlayer;
	ofSoundPlayer             nCorrectPlayer;
	
	ofxUISelfManagedImageButton* soundOnButton;
	ofxUISelfManagedImageButton* soundOffButton;
	ofxUISelfManagedImageButton* musicOnButton;
	ofxUISelfManagedImageButton* musicOffButton;
	ofxUISelfManagedImageButton* nextFaceButton;
	ofxUISelfManagedImageButton* helpButton;
	
	ofTrueTypeFont scoreFont;
	
	ofxUISelfManagedImageButton* homeButton;
	int incorrect;
	int correct;
	
	ofxUILabel* correctLabel;

};

#endif
