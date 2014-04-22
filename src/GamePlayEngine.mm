//
//  GamePlayEngine.cpp
//  CopyMe
//
//  Created by Daniel Rosser on 31/10/2013.
//
//

#include "GamePlayEngine.h"
#include "Globals.h"


GamePlayEngine::GamePlayEngine() {
    // CTOR
    tickImage = NULL;
    wellDone = NULL;
	background = NULL;
    
    tryAgainImage = NULL;
	tickImage = NULL;
	cantSeeImage2 = NULL;
    
    
    expressions = NULL;
    loader = NULL;
    
    gameStats = NULL;
    faces = NULL;
    
}

GamePlayEngine::~GamePlayEngine() {
    if(expressions) {
		delete expressions;
		expressions = NULL;
	}
    
    if(loader) {
        loader->exit();
        delete loader;
        loader = NULL;
    }
    
    // last resort
    if(delegate) {
        clearDelegate();
    }
}

//----------------------------------------------------------
void GamePlayEngine::setup() {
	
	//----------------------------------------- OpenFrameWorks iOS initialisers
	//ofxiOSSetOrientation(ofxiOS_ORIENTATION_PORTRAIT);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
	
	//------------------------------------ Old Retina Upscale code
	//	EAGLView * view = ofxiPhoneGetGLView();
	//	view.layer.magnificationFilter = kCAFilterNearest;
	//----------------------------------------------------------
	
	ofSetLogLevel(OF_LOG_SILENT);
	
    ofSetFrameRate(60);
	//ofEnableAlphaBlending();
	ofSetVerticalSync(true);
	ofBackground(32, 32, 32);
	ofEnableSmoothing();
	
	ofSeedRandom();
	
	//---------------------------------------- Game Objects / Scene Setup
	if(expressions) {
		delete expressions;
		expressions = NULL;
	}
	expressions = new Expressions();
	
	//----------------------------------------  Threaded Image Loader
	loader = new ofxThreadedImageLoader();
	loader->startThread(false);

	
	setupGame();
	load();
	
	GameSoundManager::getInstance()->setup();
}

//----------------------------------------------------------
void GamePlayEngine::exit() {
	exitGame();
	GameSoundManager::getInstance()->destroy();
    
    if(expressions) {
        expressions->exit();
		delete expressions;
		expressions = NULL;
	}
    
    if(loader) {
        loader->exit();
        delete loader;
        loader = NULL;
    }
}

//--------------------------------------------------------------
void GamePlayEngine::update(){
	
	float dt = (float)ofGetLastFrameTime();  // Should be 0.0160007 :)
	updateGame(dt);
	GameSoundManager::getInstance()->update();
	//---------------------------------------------------------- For external displays
//	if(ofxiPhoneExternalDisplay::isExternalScreenConnected()){
//		if(!ofxiPhoneExternalDisplay::isMirroring()){
//			ofxiPhoneExternalDisplay::mirrorOn();
//			ofLog(OF_LOG_NOTICE, "No Mirroring device found ");
//		}
//	}
	
}

//----------------------------------------------------------
void GamePlayEngine::touchDown(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void GamePlayEngine::touchMoved(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void GamePlayEngine::touchUp(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void GamePlayEngine::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void GamePlayEngine::touchCancelled(ofTouchEventArgs& touch){
	
}

//--------------------------------------------------------------
void GamePlayEngine::lostFocus(){
	
}

//--------------------------------------------------------------
void GamePlayEngine::gotFocus(){
    
}

//--------------------------------------------------------------
void GamePlayEngine::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void GamePlayEngine::deviceOrientationChanged(int newOrientation){
    
}

//----------------------------------------------------------
void GamePlayEngine::setDelegate(id delegate) {
	this->delegate = delegate;
}

//----------------------------------------------------------
void GamePlayEngine::clearDelegate() {
	if(delegate != nil) {
		delegate = nil;
	}
}

//----------------------------------------------------------
void GamePlayEngine::playClick() {
	GameSoundManager::getInstance()->playClickSound();
	//clickPlayer.play();
}

//----------------------------------------------------------
void GamePlayEngine::setDifficulty(int difficulty) {
	expressions->levelDifficulty = (LevelDifficultly)difficulty;
	//faces->unload();
	faces->load();
	faces->setup(expressions->levelDifficulty);
	faces->start();
}


//--------------------------------------------------------------
void GamePlayEngine::setupGame()
{
	
	isiOSReady = false;

	if(gameStats) {
		delete gameStats;
		gameStats = NULL;
	}
	gameStats = new GameStats();
	
	ofStyle style;
	style.color = ofColor(255);
	style.bgColor = ofColor(0);
	ofSetStyle(style);
	ofBackground(0);
	
	//------------------------------------------- Set images to load strings
	if(isRetina()) {
		backgroundName = "images/gamebg@2x.jpg";
		wellDoneName = "images/welldone@2x.png";
		//helpImageName = "images/helpscreen@2x.png";
		tryAgainName = "images/tryagain@2x.png";
		tickName = "images/correcttick@2x.png";
		cantSeeName2 = "images/face_portal@2x.png";
		
	} else {
		backgroundName = "images/gamebg.jpg";
		wellDoneName = "images/welldone.png";
		//helpImageName = "images/helpscreen.png";
		tryAgainName = "images/tryagain.png";
		tickName = "images/correcttick.png";
		cantSeeName2 = "images/face_portal.png";
	}
	
	faces = new FaceImages(loader);
	
//	soundPlayer.setMultiPlay(true);
//    soundPlayer.loadSound("sounds/music.mp3");
//    soundPlayer.setLoop(true);
//	soundPlayer.setVolume(1);
//	
//	soundPlayer.play();
	
	soundOn = true;
	musicOn = true;
	
	helpOn = false;
	
//	successPlayer.setMultiPlay(true);
//	successPlayer.loadSound("sounds/success.wav");
//	successPlayer.setLoop(false);
//	successPlayer.setVolume(0.6f);
//	
//	wrongPlayer.setMultiPlay(true);
//	wrongPlayer.loadSound("sounds/brightsound.wav");
//	wrongPlayer.setLoop(false);
//	wrongPlayer.setVolume(0.6f);
//	
//	nIncorrectPlayer.setMultiPlay(true);
//	nIncorrectPlayer.loadSound("sounds/ntryagain.wav");
//	nIncorrectPlayer.setLoop(false);
//	
//	nCorrectPlayer.setMultiPlay(true);
//	nCorrectPlayer.loadSound("sounds/nwelldone.wav");
//	nCorrectPlayer.setLoop(false);
//	
//	clickPlayer.setMultiPlay(true);
//	clickPlayer.loadSound("sounds/click.wav");
//	clickPlayer.setLoop(false);
//	clickPlayer.setVolume(0.2f);
	
	levelState = intro;
	
	step = 0.0f;
	incorrect = 0;
	correct = 0;
    
    // times for each game state
	
	totalIntro = 0.89f; // until things get started after complete load
	totalNoFace = 2.0f; //until the prompt face comes up
	totalPromptFace = 2.0f; // until prompt face dissapears (currently disabled)
	minFoundFace = 0.5f;
	totalFoundFace = 8.0f;
	totalCorrectFace = 3.0f;
	totalIncorrectFace = 2.0f;
	totalHelpScreen = 2.0f;
	totalSkippedFace = 0.5f;
	
	expressionTimer = 0.0f;
	totalExpressionTimer = 1.6f;
	
	levelState = loading;


}

//----------------------------------------------------------
void GamePlayEngine::exitGame()
{
	// unload resources
	unload();
	
//	// stop sounds
//    soundPlayer.stop();
//    soundPlayer.unloadSound();
//	successPlayer.stop();
//	successPlayer.unloadSound();
//	wrongPlayer.stop();
//	wrongPlayer.unloadSound();
//	nIncorrectPlayer.stop();
//	nIncorrectPlayer.unloadSound();
//	nCorrectPlayer.stop();
//	nCorrectPlayer.unloadSound();
//	
//	clickPlayer.stop();
//	clickPlayer.unloadSound();
//	
	if(gameStats) {
		delete gameStats;
		gameStats = NULL;
	}
	
	if(faces) {
		delete faces;
		faces = NULL;
	}

	
}

//--------------------------------------------------------------
void GamePlayEngine::updateGame(float dt) {
	
	if(levelState == endgame)
		return;
	
	if(levelState == loading) {
		if(hasLoaded()) {
			levelState = iosReady;
			if ( [delegate respondsToSelector:@selector(gameLoaded)] ) {
				[delegate performSelectorOnMainThread:@selector(gameLoaded) withObject:nil waitUntilDone:NO];
			}
			return;
		} else {
			return;
		}
	}
	
	//---------------------------------------------------------- iOS Ready State
	if(levelState == iosReady) {
		if(isiOSReady == true) {
			levelState = intro;
			if ( [delegate respondsToSelector:@selector(gameStarted)] ) {
				[delegate performSelectorOnMainThread:@selector(gameStarted) withObject:nil waitUntilDone:NO];
			}
			return;
		} else {
			return;
		}
	}
	//---------------------------------------------------------- Intro State
	if(levelState == intro)
	{
		if(step == 0.0f)
		{
			
		}
		// if hasLoaded then continue
		if(hasLoaded()) {
			expressions->startCamera();
			step += ofGetLastFrameTime();
		}
		if(step >= totalIntro) {
			
			faces->playNarration();
			levelState = noFace;
			step = 0.0f;
			incorrect = 0;
			return;
		}
	}
	//---------------------------------------------------------- Game Engine Loaded and Ready
	
	gameStats->update(dt);
	if(levelState != loading && levelState != intro) {
		expressions->update();
	}
	
	//---------------------------------------------------------- No Face Found
	if(levelState == noFace) {
		step += ofGetLastFrameTime();
		
		if(expressions->getExpression() != NO_EXPRESSION) {
			levelState = foundFace;
			step = 0.0f;
		}
		
		if(step >= totalNoFace) {
			levelState = promptFace;
			step = 0.0f;
		}
	}
	//---------------------------------------------------------- Found a Face
	else if (levelState == foundFace) {

		step += ofGetLastFrameTime();
		
		if(step >= minFoundFace) {
			if(expressions->getExpression() == faces->getCurrent()->expression) {
				expressionTimer += ofGetLastFrameTime();
				if(expressionTimer >=  totalExpressionTimer) {
					levelState = correctFace;
					step = 0.0f;
					expressionTimer = 0.0f;
				} else {
					step = minFoundFace + 0.1f;
				}
			}
		}
		if(step >= totalFoundFace) {
			levelState = incorrectFace;
			step = 0.0f;
		}
		else if(expressions->getExpression() == NO_EXPRESSION){
			levelState = noFace;
			step = 0.0f;
		}
		
	}
	//---------------------------------------------------------- Correct Face
	else if(levelState == correctFace) {
		if(step == 0.0f) {
			GameSoundManager::getInstance()->playCorrectSound();
			GameSoundManager::getInstance()->playWellDoneSound();
//			successPlayer.play();
//			nCorrectPlayer.play();
		}
		step += ofGetLastFrameTime();
		if(step >= totalCorrectFace) {
			levelState = noFace;
			faces->getCurrent()->correct();
			correct++;
			if ( [delegate respondsToSelector:@selector(scoreChanged)] ) {
				[delegate performSelectorOnMainThread:@selector(scoreChanged) withObject:nil waitUntilDone:NO];
			}
			faces->getNext();
			faces->playNarration();
//----------------------------------------------------------
#ifdef NOT_IPAD_SIMULATOR
			
#else
			/// FOR SIMULATOR ONLY
			expressions->colorCv = faces->current->image->getPixels();
#endif
//----------------------------------------------------------
			step = 0.0f;
			incorrect = 0;
		}
	}
	//---------------------------------------------------------- Incorrect Face
	else if(levelState == incorrectFace) {
		// first frame
		if(step == 0.0f){
			GameSoundManager::getInstance()->playTryAgainSound();
			GameSoundManager::getInstance()->playIncorrectSound();
//			wrongPlayer.play();
//			nIncorrectPlayer.play();
		}
		// @ Feedback text on screen
		step += ofGetLastFrameTime();
		if(step >= totalIncorrectFace) {
			expressionTimer = 0.0f;
			faces->getCurrent()->incorrect();
			levelState = noFace;
			step = 0.0f;
			incorrect++;
			if(incorrect>=5) {
				levelState = incorrectSkippedFace;
			}
		}
	}
	//---------------------------------------------------------- Prompt Face
	else if(levelState == promptFace) {
		step += ofGetLastFrameTime();
		if(expressions->getExpression() != NO_EXPRESSION) {
			levelState = foundFace;
			step = 0.0f;
		}
	}
	//---------------------------------------------------------- Help Screen
	else if(levelState == helpScreen) {
		step += ofGetLastFrameTime();
		if(step >= totalHelpScreen) {
			levelState = noFace;
			step = 0.0f;
		}
		
	}
	//---------------------------------------------------------- skipped Face
	else if(levelState == skippedFace)
	{
		step += ofGetLastFrameTime();
		if(step >= totalSkippedFace) {
			expressionTimer = 0.0f;
			levelState = noFace;
			faces->getCurrent()->skipped();
			faces->getNext();
			faces->playNarration();
#ifdef NOT_IPAD_SIMULATOR
			
#else
			expressions->colorCv = faces->current->image->getPixels();
#endif
			step = 0.0f;
			incorrect = 0;
		}
	}
	//---------------------------------------------------------- Incorrect Skipped Face
	else if(levelState == incorrectSkippedFace) {
		step += ofGetLastFrameTime();
		if(step >= totalSkippedFace) {
			expressionTimer = 0.0f;
			levelState = noFace;
			faces->getCurrent()->skipped();
			faces->getNext();
			faces->playNarration();
#ifdef NOT_IPAD_SIMULATOR
			
#else
			expressions->colorCv = faces->current->image->getPixels();
#endif
			step = 0.0f;
			incorrect = 0;
		}
	}
}

//---------------------------------------------------------- Draw
void GamePlayEngine::draw() {
	ofPushStyle();
	ofSetColor(255, 255, 255, 255);
	//ofRect(0, 0, 768, 1024);
	drawGame();
	ofPopStyle();
	//
}

//--------------------------------------------------------------
void GamePlayEngine::drawGame()
{
	if(levelState == endgame)
		return;
	
	ofSetRectMode(OF_RECTMODE_CORNER);
	// background
	ofBackground(0,0,0);
	
	if(levelState == loading) {
		return;
	}
	
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	
	expressions->drawASD();
	
	ofEnableAlphaBlending();
	
	ofSetColor(255,255,255,255);
    faces->draw();
	
	// top layers based on states
	
	//---------------------------------------------------------- No Face
	if(levelState == noFace) {
		// Don't draw anything special in no face
	}
	//---------------------------------------------------------- Found Face
	else if (levelState == foundFace) {
		ofPushStyle();
		ofSetColor(155, 155, 155, 155);
		int per = (expressionTimer*100)/totalExpressionTimer;
		if(isRetina()) {
			ofRect(260, 298, 10 * per + 20, 146);
		} else {
			ofRect(130, 149, 5 * per + 10, 73);
		}
		
		ofPopStyle();
	}
	//---------------------------------------------------------- Correct Face
	else if(levelState == correctFace) {
		ofPushStyle();
		ofSetColor(155, 255, 155, 155);
		int per = 100;
		if(isRetina()) {
			ofRect(260, 298, 10 * per + 20, 146);
		} else {
			ofRect(130, 149, 5 * per + 10, 73);
		}
		ofPopStyle();
		
		ofPushStyle();
		ofSetColor(255, 255, 255, step/(totalCorrectFace/2)*255);
		if(wellDone) {
			if(isRetina()) {
				wellDone->draw(0, 300);
			} else {
				wellDone->draw(0, 150);
			}
		}
		ofPopStyle();
	}
	//---------------------------------------------------------- Incorrect Face
	else if(levelState == incorrectFace) {
		ofPushStyle();
		ofSetColor(255, 155, 155, 155);
		int per = (expressionTimer*100)/totalExpressionTimer;
		if(isRetina()) {
			ofRect(260, 298, 10 * per + 20, 146);
		} else {
			ofRect(130, 149, 5 * per + 10, 73);
		}
		ofPopStyle();
		
		ofPushStyle();
		ofSetColor(255, 255, 255, step/(totalIncorrectFace/2)*255);
		if(tryAgainImage) {
			if(isRetina()) {
				tryAgainImage->draw(0, 300);
			} else {
				tryAgainImage->draw(0, 150);
			}
		}
		ofPopStyle();
		
	}
	//---------------------------------------------------------- Prompt Face
	else if(levelState == promptFace) {
		ofPushStyle();
		ofSetColor(255, 255, 255, step/(totalPromptFace/2)*255);
		if(cantSeeImage2) {
			if(isRetina()) {
				cantSeeImage2->draw(784, 530, 720, 960);
			} else {
				cantSeeImage2->draw(16+360+16, 265, 360, 480);
			}
		}
		ofPopStyle();
	}
	//---------------------------------------------------------- Help Screen
	else if(levelState == helpScreen) {
		if(helpOn) {
			//
		}
	}
	//---------------------------------------------------------- Skipped Face
	else if(levelState == skippedFace) {
		// Don't draw anything special for skipped face
	}
	//---------------------------------------------------------- Incorrect Skipped Face
	else if(levelState == incorrectSkippedFace) {
		// Don't draw anything special for skipped face
	}
	
	//----------------------------------------------------------
	if(helpOn == true && levelState != helpScreen)
	{
		//
	}
	
	//----------------------------------------------------------
	if(tickImage) {
		if(isRetina()) {
			if(correct < 10) {
				tickImage->draw(180, 60);
			} else if(correct < 100) {
				tickImage->draw(180+72, 60);
			} else if(correct < 1000) {
				tickImage->draw(180+72*2, 60);
			} else if(correct < 10000) {
				tickImage->draw(180+72*3, 60);
			}  else if(correct < 100000) {
				tickImage->draw(180+72*4, 60);
			}
		} else {
			if(correct < 10) {
				tickImage->draw(90, 30);
			} else if(correct < 100) {
				tickImage->draw(90+36, 30);
			} else if(correct < 1000) {
				tickImage->draw(90+36*2, 30);
			} else if(correct < 10000) {
				tickImage->draw(90+36*3, 30);
			}  else if(correct < 100000) {
				tickImage->draw(90+36*4, 30);
			}
		}
	}
	//----------------------------------------------------------
	ofSetColor(0, 0, 0, 196);
    
}

//----------------------------------------------------------
void GamePlayEngine::load()
{
	//----------------------------------------------------------
	if(!tickImage) {
		tickImage = new ofImage();
		loader->loadFromDisk(*tickImage, tickName);
		ofLog(OF_LOG_NOTICE, "tickImage image loaded: " + tickName);
	}
	else {
		ofLog(OF_LOG_NOTICE, "! tickImage image already loaded: " + tickName);
	}
	//----------------------------------------------------------
	if(!background) {
		background = new ofImage();
		loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
	}
	else {
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	}
	//----------------------------------------------------------
	if(!wellDone) {
		wellDone = new ofImage();
		loader->loadFromDisk(*wellDone, wellDoneName);
		ofLog(OF_LOG_NOTICE, "wellDone image loaded: " + wellDoneName);
	}
	else {
		ofLog(OF_LOG_NOTICE, "! wellDone image already loaded: " + wellDoneName);
	}
	
	//----------------------------------------------------------
	if(!tryAgainImage) {
		tryAgainImage = new ofImage();
		loader->loadFromDisk(*tryAgainImage, tryAgainName);
		ofLog(OF_LOG_NOTICE, "tryAgainImage image loaded: " + tryAgainName);
	}
	else {
		ofLog(OF_LOG_NOTICE, "! tryAgainImage image already loaded: " + tryAgainName);
	}
	
	//----------------------------------------------------------
	if(!cantSeeImage2) {
		cantSeeImage2 = new ofImage();
		loader->loadFromDisk(*cantSeeImage2, cantSeeName2);
		ofLog(OF_LOG_NOTICE, "cantSeeImage2 image loaded: " + cantSeeName2);
	}
	else {
		ofLog(OF_LOG_NOTICE, "! cantSeeImage2 image already loaded: " + cantSeeName2);
	}
	
	//----------------------------------------------------------
	//----------------------------------------------------------
	faces->load();
	//faces->setup(expressions->levelDifficulty);
	//faces->start();
}

//----------------------------------------------------------
void GamePlayEngine::unload()
{
	//----------------------------------------------------------
	if(background) {
		//loader->removeLoading(*backgroundName);
		ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
		background->unbind();
		delete background;
		background = NULL;
	}
	//----------------------------------------------------------
	if(wellDone) {
		//loader->removeLoading(*wellDoneName);
		ofLog(OF_LOG_NOTICE, "wellDone image unloaded: " + wellDoneName);
		wellDone->unbind();
		delete wellDone;
		wellDone = NULL;
	}
	//----------------------------------------------------------
	if(tryAgainImage) {
		//loader->removeLoading(*tryAgainName);
		ofLog(OF_LOG_NOTICE, "tryAgainImage image unloaded: " + tryAgainName);
		tryAgainImage->unbind();
		delete tryAgainImage;
		tryAgainImage = NULL;
	}
	//----------------------------------------------------------
	if(tickImage) {
		//loader->removeLoading(*tickName);
		ofLog(OF_LOG_NOTICE, "tickImage image unloaded: " + tickName);
		tickImage->unbind();
		delete tickImage;
		tickImage = NULL;
	}
	//----------------------------------------------------------
	if(cantSeeImage2) {
		//loader->removeLoading(*cantSeeName2);
		ofLog(OF_LOG_NOTICE, "cantSeeImage2 image unloaded: " + cantSeeName2);
		cantSeeImage2->unbind();
		delete cantSeeImage2;
		cantSeeImage2 = NULL;
	}
	//----------------------------------------------------------
	//----------------------------------------------------------
	if(faces) {
		faces->unload();
	}
}

//----------------------------------------------------------
void GamePlayEngine::helpButtonPressed() {

		helpOn = !helpOn;
		levelState = helpScreen;
		step = 0.0f;
}

//----------------------------------------------------------
void GamePlayEngine::soundOnButtonPressed() {
		faces->muteNarration = true;
		soundOn = false;
//		successPlayer.setVolume(0);
//		wrongPlayer.setVolume(0);
//		clickPlayer.setVolume(0);
//		nCorrectPlayer.setVolume(0);
//		nIncorrectPlayer.setVolume(0);
		GameSoundManager::getInstance()->setMute(true);
}

//----------------------------------------------------------
void GamePlayEngine::soundOffButtonPressed() {
		faces->muteNarration = false;
		soundOn = true;
//		successPlayer.setVolume(0.6);
//		wrongPlayer.setVolume(0.6);
//		clickPlayer.setVolume(0.2f);
//		nCorrectPlayer.setVolume(1);
//		nIncorrectPlayer.setVolume(1);
	    GameSoundManager::getInstance()->setMute(false);
}

//----------------------------------------------------------
void GamePlayEngine::musicOnButtonPressed() {
		musicOn = false;
		//soundPlayer.setVolume(0);
		GameSoundManager::getInstance()->setMuteMusic(true);
}

//----------------------------------------------------------
void GamePlayEngine::musicOffButtonPressed() {
		musicOn = true;
		//soundPlayer.setVolume(1);
		GameSoundManager::getInstance()->setMuteMusic(false);
}

//----------------------------------------------------------
void GamePlayEngine::nextFaceButtonPressed() {
	step = 0.0f;
	levelState = skippedFace;
}

//----------------------------------------------------------
bool GamePlayEngine::hasLoaded()
{
	//----------------------------------------------------------
	// if all the images have loaded (buttons and background)
	if(
	   wellDone != NULL && wellDone->isAllocated() &&
	   background != NULL && background->isAllocated() &&
	   tryAgainImage != NULL && tryAgainImage->isAllocated() &&
	   tickImage != NULL && tickImage->isAllocated() &&
	   cantSeeImage2 != NULL && cantSeeImage2->isAllocated() &&
	   faces->hasLoaded()
	   )
	{
		return true;
	}
	else {
		return false;
	}
	//----------------------------------------------------------
}

void GamePlayEngine::setiOSReady(bool value) {
	isiOSReady = value;
	if(isiOSReady == false) {
		levelState = loading;
	}
}

int GamePlayEngine::getScore() {
	return correct;
}
