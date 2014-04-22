#ifndef CopyMe_GameWeb_h
#define CopyMe_GameWeb_h

#include "ofMain.h"
#include "ofxScene.h"
#include "ofxSceneManager.h"
#include "ofxUI.h"
#include "UISelfManagedImageButton.h"

// Web stuff
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxiPhoneWebViewController.h"

// gif
#include "ofxGifDecoder.h"
#include "ofxGifFile.h"

class GameWeb : public ofxScene{
	
	
	void setup();
	void update(float dt);
	void draw();
    void exit();
	void setupWeb();
    
    
	void sceneWillAppear( ofxScene * fromScreen );
	void sceneWillDisappear( ofxScene * toScreen );
    void sceneDidAppear();
    void sceneDidDisappear( ofxScene * fromScreen );
    
    void windowResized(int w, int h);
	void dragEvent(ofDragInfo dragInfo);
	void gotMessage(ofMessage msg);
    
	void setGUI();
	
	void load();
	void unload();
	
	bool hasLoaded();
	
    
    //--------------------------------------------------------------
    void guiEvent(ofxUIEventArgs &e);
	
	
private:
	
	ofImage* background;
	ofSoundPlayer* clickPlayer;
	string backgroundName;
	
	ofxUISelfManagedImageButton* homeButton;
	
	ofxiPhoneWebViewController inlineWebViewController;
    void webViewEvent(ofxiPhoneWebViewControllerEventArgs &args);
    
    void openFullscreen();
    
    int doubleTapCount;
    UILabel *label;
	
	ofxGifDecoder dcd;
	ofxGifFile loading;
	int frameIndex;
	
	enum WebState { WEB_LOADING =0, WEB_LOADED, WEB_FAILED };
	WebState webState;
	
	
};


#endif
