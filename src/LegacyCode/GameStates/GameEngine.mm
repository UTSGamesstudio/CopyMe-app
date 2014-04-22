#include "GameEngine.h"


//--------------------------------------------------------------
void GameEngine::setup(){
	
	//----------------------------------------- OpenFrameWorks iOS initialisers
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
	
	//make retina devices upscale with nearest (not default linear)
//	EAGLView * view = ofxiPhoneGetGLView();
//	view.layer.magnificationFilter = kCAFilterNearest;
	
	ofSetLogLevel(OF_LOG_SILENT);
	
    ofSetFrameRate(60);
	//ofEnableAlphaBlending();
	ofSetVerticalSync(true);
	ofBackground(32, 32, 32);
    //ofRegisterTouchEvents(this);
    //ofxAccelerometer.setup();
	ofEnableSmoothing();
	
	ofSeedRandom();
	
	//---------------------------------------- Game Objects / Scene Setup
    sceneManager = new ofxSceneManager();
	sceneManager->setOverlapUpdate(true);
	
	
	//expressions = new Expressions();
	
	if(sceneManager->expressions)
	{
		delete sceneManager->expressions;
		sceneManager->expressions= NULL;
	}
	sceneManager->expressions = new Expressions();
	 
    
    if(sceneManager->sharedGUI)
    {
        delete sceneManager->sharedGUI;
        sceneManager->sharedGUI = NULL;
    }
    sceneManager->sharedGUI = new ofxUICanvas();
    sceneManager->sharedGUI->disable();
    sceneManager->sharedGUI->disableAppEventCallbacks();
    sceneManager->sharedGUI->disableKeyEventCallbacks();
    sceneManager->sharedGUI->disableTouchEventCallbacks();
	sceneManager->sharedGUI->setAutoDraw(false);
	
	// Image Loader // Threaded
	sceneManager->loader = new ofxThreadedImageLoader();
	sceneManager->loader->startThread(false, false);
	
	// Shared Resources
	sceneManager->shared = new SharedResources();
	sceneManager->shared->load();
    
	// Game States / Scenes
	intro = new GameIntro();
	outro = new GameOutro();
	play = new GamePlay();
	
	sceneManager->addScene( intro, INTRO);
	//sceneManager->addScene( new GameMenu(), MENU);
	sceneManager->addScene( play, GAME_PLAY);
	sceneManager->addScene( outro, OUTRO);
    //sceneManager->addScene( new GamePlayMenu(), GAME_PLAY_MENU);
	//sceneManager->addScene( new GameAbout(), ABOUT);
	//sceneManager->addScene( new GameWeb(), SURVEY);
	
	if(delegate) {
		sceneManager->setDelegate(delegate);
	}
	
	// Game Curtain / Fade Times
	sceneManager->setDrawDebug(false);
	sceneManager->setCurtainDropTime(0.3);
	sceneManager->setCurtainStayTime(0.0);
	sceneManager->setCurtainRiseTime(0.3);
	
	clickPlayer = sceneManager->shared->clickPlayer;
	
	//sceneManager->getScene(MENU)->load();
	//sceneManager->setOverlapUpdate(true);
	
}

GameEngine::GameEngine() {
	
}

//--------------------------------------------------------------
void GameEngine::update(){
	
	float dt = (float)ofGetLastFrameTime();  // Should be 0.0160007 :)
	sceneManager->update( dt );
	if(ofxiPhoneExternalDisplay::isExternalScreenConnected()){
		if(!ofxiPhoneExternalDisplay::isMirroring()){
			ofxiPhoneExternalDisplay::mirrorOn();
			ofLog(OF_LOG_NOTICE, "No Mirroring device found ");
		}
	}
	
}

//--------------------------------------------------------------
void GameEngine::draw(){	
	sceneManager->draw();

	
}

//--------------------------------------------------------------
void GameEngine::exit(){   
    
    sceneManager->exit();
	if(intro) {
		delete intro;
		intro = NULL;
	}
	if(play) {
		delete play;
		play = NULL;
	}
	if(outro) {
		delete outro;
		outro = NULL;
	}
}

//--------------------------------------------------------------
void GameEngine::touchDown(ofTouchEventArgs & touch){
	sceneManager->touchDown(touch);
}

//--------------------------------------------------------------
void GameEngine::touchMoved(ofTouchEventArgs & touch){
	sceneManager->touchMoved(touch);
}

//--------------------------------------------------------------
void GameEngine::touchUp(ofTouchEventArgs & touch){
	sceneManager->touchUp(touch);
}

//--------------------------------------------------------------
void GameEngine::touchDoubleTap(ofTouchEventArgs & touch){
    sceneManager->touchDoubleTap(touch);
    
}

//--------------------------------------------------------------
void GameEngine::touchCancelled(ofTouchEventArgs& touch){
	sceneManager->touchCancelled(touch);
}

//--------------------------------------------------------------
void GameEngine::lostFocus(){
   
}

//--------------------------------------------------------------
void GameEngine::gotFocus(){
    
}

//--------------------------------------------------------------
void GameEngine::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void GameEngine::deviceOrientationChanged(int newOrientation){
    
}

void GameEngine::setDelegate(id delegate) {
	this->delegate = delegate;
}

void GameEngine::clearDelegate() {
    if(sceneManager) {
		sceneManager->clearDelegate();
	}
	if(delegate != nil) {
		delegate = nil;
	}
}

void GameEngine::playClick() {
	clickPlayer->play();
}

void GameEngine::setDifficulty(int difficulty) {
	if(sceneManager->expressions) {
		sceneManager->expressions->levelDifficulty = (LevelDifficultly)difficulty;
	}
}



