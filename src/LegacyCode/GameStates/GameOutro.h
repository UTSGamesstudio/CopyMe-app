#ifndef CopyMe_GameOutro_h
#define CopyMe_GameOutro_h

#include "ofMain.h"
#include "ofxScene.h"
#include "ofxAnimatableFloat.h"

class GameOutro : public ofxScene{
	
	
	void setup(){  
		step = 0;
		maxStep = 0.25f;
		done = false;
	};
	
	
	void update(float dt){ //update scene 1 here		
		step += ofGetLastFrameTime();
		if(step >= maxStep && done == false)
		{
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
