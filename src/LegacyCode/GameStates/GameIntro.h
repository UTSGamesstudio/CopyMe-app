#ifndef GamePrototype_GameIntro_h
#define GamePrototype_GameIntro_h

#include "ofMain.h"
#include "ofxScene.h"
#include "ofxAnimatableFloat.h"

class GameIntro : public ofxScene{
	
	
	void setup(){  
		step = 0;
		maxStep = 0.0f;
		done = false;
	};
	
	
	void update(float dt){ //update scene 1 here		
		step += ofGetLastFrameTime();
		if(step >= maxStep && done == false)
		{
			getManager()->getScene(GAME_PLAY)->load();
			getManager()->goToScene(GAME_PLAY);
			done = true;
		}
	};
	
	void draw(){
		ofBackground(0,0,0,255);
		
	};
	
	//scene notifications
	void sceneWillAppear( ofxScene * fromScreen ){  // reset our scene when we appear
		
	};
	
	//scene notifications
	void sceneWillDisappear( ofxScene * toScreen ){ 
	
	}

private:
	float step;
	float maxStep;
	bool done;
};



#endif
