
#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"


#include "AppDelegate.h"

int main(){
	ofAppiOSWindow * window = new ofAppiOSWindow();
    //window->enableRendererES2();
    window->enableRetina();
  //  window->enableDepthBuffer();
    
	if(window->isRetinaEnabled()){
		ofSetupOpenGL(ofPtr<ofAppBaseWindow>(window), 2048, 1536, OF_FULLSCREEN);
	} else {
		ofSetupOpenGL(ofPtr<ofAppBaseWindow>(window), 1024, 768, OF_FULLSCREEN);
	}
	window->startAppWithDelegate("AppDelegate");
}
