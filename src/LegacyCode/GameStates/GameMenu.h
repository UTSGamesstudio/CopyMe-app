#ifndef GamePrototype_GameMenu_h
#define GamePrototype_GameMenu_h

#include "ofMain.h"
#include "ofxScene.h"
#include "ofxSceneManager.h"
#include "ofxUI.h"
#include "UISelfManagedImageButton.h"

class GameMenu : public ofxScene{
	
	
	void setup();	
	void update(float dt);	
	void draw();
    void exit();
    
    
	void sceneWillAppear( ofxScene * fromScreen );	
	void sceneWillDisappear( ofxScene * toScreen );
    void sceneDidAppear();
    void sceneDidDisappear( ofxScene * fromScreen );
    
    void windowResized(int w, int h);
	void dragEvent(ofDragInfo dragInfo);
	void gotMessage(ofMessage msg);
	
	void load();
	void loadNormal();
	void unload();
	void unloadGUI();
	
	bool hasLoaded();
    
	void setGUI();      
     
    
    //--------------------------------------------------------------
    void guiEvent(ofxUIEventArgs &e);
   
	
private:
	
	ofImage* background;
	ofSoundPlayer* clickPlayer;
	string backgroundName;
	
	ofxUISelfManagedImageButton* playButton;
	ofxUISelfManagedImageButton* aboutButton;
	ofxUISelfManagedImageButton* surveyButton;

};



#endif
