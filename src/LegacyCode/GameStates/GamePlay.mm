#include "GamePlay.h"
#include "Globals.h"

//--------------------------------------------------------------
void GamePlay::setup()
{
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
	
	gameStats = new GameStats();
	
	ofSetLogLevel(OF_LOG_NOTICE);
	
	ofStyle style;
	style.color = ofColor(255);
	style.bgColor = ofColor(0);
	ofSetStyle(style);
	ofBackground(0);
	
	if(isRetina()) {
		backgroundName = "images/gamebg@2x.jpg";
		wellDoneName = "images/welldone@2x.png";
		helpImageName = "images/helpscreen@2x.png";
		tryAgainName = "images/tryagain@2x.png";
		tickName = "images/correcttick@2x.png";
		cantSeeName2 = "images/face_portal@2x.png";
		
	} else {
		backgroundName = "images/gamebg.jpg";
		wellDoneName = "images/welldone.png";
		helpImageName = "images/helpscreen.png";
		tryAgainName = "images/tryagain.png";
		tickName = "images/correcttick.png";
		cantSeeName2 = "images/face_portal.png";
	}
	
	setGUI();
	gui->setDrawBack(false);
	gui->disable();
	gui->disableAppEventCallbacks();
	
	faces = new FaceImages(getManager()->loader);
	
	soundPlayer.setMultiPlay(true);
    soundPlayer.loadSound("sounds/music.mp3");
    soundPlayer.setLoop(true);
	soundPlayer.setVolume(1);
	soundOn = true;
	musicOn = true;
	
	helpOn = false;
	
	successPlayer.setMultiPlay(true);
	successPlayer.loadSound("sounds/success.wav");
	successPlayer.setLoop(false);
	successPlayer.setVolume(0.6f);
	
	wrongPlayer.setMultiPlay(true); 
	wrongPlayer.loadSound("sounds/brightsound.wav");
	wrongPlayer.setLoop(false);
	wrongPlayer.setVolume(0.6f);
	
	clickPlayer = (getManager()->shared->clickPlayer);
	//clickPlayer.setMultiPlay(true);
	//clickPlayer.loadSound("sounds/click.wav");
	//clickPlayer.setLoop(false);
	//clickPlayer.setVolume(0.2f);
	
	
	nIncorrectPlayer.setMultiPlay(true);
	nIncorrectPlayer.loadSound("sounds/ntryagain.wav");
	nIncorrectPlayer.setLoop(false);
	
	nCorrectPlayer.setMultiPlay(true);
	nCorrectPlayer.loadSound("sounds/nwelldone.wav");
	nCorrectPlayer.setLoop(false);
	
	levelState = intro;
	
	step = 0.0f;
	incorrect = 0;
	correct = 0;
    
    // times for each game state
	
	totalIntro = 0.5f; // until things get started after complete load
	totalNoFace = 2.0f; //until the prompt face comes up
	totalPromptFace = 2.0f; // until prompt face dissapears (currently disabled)
	minFoundFace = 1.0f; 
	totalFoundFace = 8.0f;
	totalCorrectFace = 3.0f;
	totalIncorrectFace = 2.0f;
	totalHelpScreen = 2.0f;
	totalSkippedFace = 0.5f;
	
	expressionTimer = 0.0f;
	totalExpressionTimer = 1.6f;
	
	scoreFont.loadFont("hyperion.ttf", 38);
	
	
	
}

void GamePlay::exit()
{
	unload();
    soundPlayer.stop();
    soundPlayer.unloadSound();
	successPlayer.stop();
	successPlayer.unloadSound();
	wrongPlayer.stop();
	wrongPlayer.unloadSound();
	nIncorrectPlayer.stop();
	nIncorrectPlayer.unloadSound();
	nCorrectPlayer.stop();
	nCorrectPlayer.unloadSound();
	ofRemoveListener(gui->newGUIEvent,this,&GamePlay::guiEvent);
	gui->exit();
	if(gui)
	{	delete gui;
		gui = NULL;
	}
	if(gameStats)
	{   delete gameStats;
		gameStats = NULL;
	}
	
	if(faces)
	{
		delete faces;
		faces = NULL;
	}
	
	clickPlayer = NULL;
	
}

//--------------------------------------------------------------
void GamePlay::update(float dt)
{
	
	if(levelState == endgame)
		return;
	
	if(levelState == intro)
	{
		if(step == 0.0f)
		{
#ifdef NOT_IPAD_SIMULATOR
			
#else
			// @todo
			//if(faces->current->image)
			//	getManager()->expressions->colorCv = faces->current->image->getPixels();
#endif
		}
		// if hasLoaded then continue
		if(hasLoaded())
			step += ofGetLastFrameTime();
		if(step >= totalIntro)
		{
			faces->playNarration();
			levelState = noFace;
			step = 0.0f;
			incorrect = 0;
			return;
		}
	}
	
	// Happen no matter what:
	
	gameStats->update(dt);
	if(levelState != loading && levelState != intro) {
		getManager()->expressions->update();
	}
	gui->update();
	
	if(levelState == noFace)
	{
		//if(step == 0.0f) // first frame
		//{
		//
		//}
		step += ofGetLastFrameTime();
		
		if(getManager()->expressions->getExpression() != NO_EXPRESSION)
		{	levelState = foundFace;
			step = 0.0f;
		}

		if(step >= totalNoFace)
		{
			levelState = promptFace;
			step = 0.0f;
		}
	}
	else if (levelState == foundFace)
	{
		
		//if(step == 0.0f) // first frame
		//{
		//	voicePlayer.play();
		//}
		step += ofGetLastFrameTime();
		
		if(step >= minFoundFace)
		{
			if(getManager()->expressions->getExpression() == faces->getCurrent()->expression)
			{
				expressionTimer += ofGetLastFrameTime();
				if(expressionTimer >=  totalExpressionTimer)
				{
					levelState = correctFace;
					step = 0.0f;
					expressionTimer = 0.0f;
				}
			}
		}
		
		if(step >= totalFoundFace)
		{
			levelState = incorrectFace;
			step = 0.0f;
		}
		else if(getManager()->expressions->getExpression() == NO_EXPRESSION)
		{	levelState = noFace;
			step = 0.0f;
		}
	
	}
	else if(levelState == correctFace)
	{
		if(step == 0.0f) // first frame
		{
			successPlayer.play();
			nCorrectPlayer.play();
		}
		step += ofGetLastFrameTime();
		if(step >= totalCorrectFace)
		{
			levelState = noFace;
			faces->getCurrent()->correct();
			correct++;
			//correctLabel->setLabel(ofToString());
			faces->getNext();
			faces->playNarration();
#ifdef NOT_IPAD_SIMULATOR

#else
			getManager()->expressions->colorCv = faces->current->image->getPixels();
#endif
			step = 0.0f;
			incorrect = 0;
		}
	}
	else if(levelState == incorrectFace)
	{
		if(step == 0.0f) // first frame
		{
			wrongPlayer.play();
			nIncorrectPlayer.play();
		}
		// @ Feedback text on screen
		step += ofGetLastFrameTime();
		if(step >= totalIncorrectFace)
		{
			expressionTimer = 0.0f;
			faces->getCurrent()->incorrect();
			levelState = noFace;
			step = 0.0f;
			incorrect++;
			if(incorrect>=5)
			{
				levelState = incorrectSkippedFace;
			}
		}
	}
	else if(levelState == promptFace)
	{
		//if(step == 0.0f)
		step += ofGetLastFrameTime();
		/**if(step >= totalPromptFace)
		{
			levelState = noFace;
			step = 0.0f;
		}
		 */
		if(getManager()->expressions->getExpression() != NO_EXPRESSION)
		{	levelState = foundFace;
			step = 0.0f;
		}
	}
	else if(levelState == helpScreen)
	{
		//if(step == 0.0f)
		// Help state
		step += ofGetLastFrameTime();
		if(step >= totalHelpScreen)
		{
			levelState = noFace;
			step = 0.0f;
		}
		
	}
	else if(levelState == skippedFace)
	{
		//if(step == 0.0f)
		// Help state
		step += ofGetLastFrameTime();
		if(step >= totalSkippedFace)
		{
			expressionTimer = 0.0f;
			levelState = noFace;
			faces->getCurrent()->skipped();
			faces->getNext();
			faces->playNarration();
#ifdef NOT_IPAD_SIMULATOR
			
#else
			getManager()->expressions->colorCv = faces->current->image->getPixels();
#endif
			step = 0.0f;
			incorrect = 0;
		}
		
	}
	else if(levelState == incorrectSkippedFace)
	{
		//if(step == 0.0f)
		// Help state
		step += ofGetLastFrameTime();
		if(step >= totalSkippedFace)
		{
			expressionTimer = 0.0f;
			levelState = noFace;
			faces->getCurrent()->skipped();
			faces->getNext();
			faces->playNarration();
#ifdef NOT_IPAD_SIMULATOR
			
#else
			getManager()->expressions->colorCv = faces->current->image->getPixels();
#endif
			step = 0.0f;
			incorrect = 0;
		}
		
	}
}

//--------------------------------------------------------------
void GamePlay::draw()
{
	if(levelState == endgame)
		return;
	
	ofSetRectMode(OF_RECTMODE_CORNER);
	// background
	ofBackground(0,0,0);
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	
	gui->draw();
	getManager()->expressions->drawASD();
	
	ofEnableAlphaBlending();

	ofSetColor(255,255,255,255);
    faces->draw();
	
	// top layers based on states
	
	if(levelState == noFace)
	{
		//ofDrawBitmapString("noFace", ofGetHeight()/2, ofGetWidth()/2);
	}
	else if (levelState == foundFace)
	{
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
	else if(levelState == correctFace)
	{
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
	else if(levelState == incorrectFace)
	{
		ofPushStyle();
		ofSetColor(255, 155, 155, 155);
		int per = (expressionTimer*100)/totalExpressionTimer;
		if(isRetina()) {
			ofRect(260, 298, 10 * per + 20, 146);
		} else {
			ofRect(130, 149, 5 * per + 10, 73);
		}
		//ofDrawBitmapString("incorrectFace", ofGetHeight()/2, ofGetWidth()/2);
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
	else if(levelState == promptFace)
	{
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
	else if(levelState == helpScreen)
	{
		if(helpOn)
		{
		ofPushStyle();
		ofSetColor(255, 255, 255, step/(totalHelpScreen/4)*255);
		if(helpImage)
			helpImage->draw(0, 0);
		ofPopStyle();
		}
	}
	else if(levelState == skippedFace)
	{
		//ofDrawBitmapString("skippedFace", ofGetHeight()/2, ofGetWidth()/2);
	}
	else if(levelState == incorrectSkippedFace)
	{
		//ofDrawBitmapString("incorrectSkippedFace", ofGetHeight()/2, ofGetWidth()/2);
	}
	
	if(helpOn == true && levelState != helpScreen)
	{
		ofPushStyle();
		ofSetColor(255, 255, 255, 255);
		if(helpImage)
			helpImage->draw(0, 0);
		ofPopStyle();
	}
	
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
	
	ofSetColor(0, 0, 0, 196);
	if(isRetina()) {
		scoreFont.drawString(ofToString(correct), 64, 152);
	} else {
		scoreFont.drawString(ofToString(correct), 32, 76);
	}
    
}

// Dan's image loader manager

void GamePlay::load()
{
//	soundOnButton->load(getManager()->loader);
//	soundOffButton->load(getManager()->loader);
//	musicOnButton->load(getManager()->loader);
//	musicOffButton->load(getManager()->loader);
	nextFaceButton->load(getManager()->loader);
//	helpButton->load(getManager()->loader);
	//homeButton->load(getManager()->loader);

	if(!tickImage)
	{
		tickImage = new ofImage();
		getManager()->loader->loadFromDisk(*tickImage, tickName);
		ofLog(OF_LOG_NOTICE, "tickImage image loaded: " + tickName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! tickImage image already loaded: " + tickName);
	if(!background)
	{
		background = new ofImage();
		getManager()->loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	if(!wellDone)
	{
		wellDone = new ofImage();
		getManager()->loader->loadFromDisk(*wellDone, wellDoneName);
		ofLog(OF_LOG_NOTICE, "wellDone image loaded: " + wellDoneName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! wellDone image already loaded: " + wellDoneName);
	
	if(!tryAgainImage)
	{
		tryAgainImage = new ofImage();
		getManager()->loader->loadFromDisk(*tryAgainImage, tryAgainName);
		ofLog(OF_LOG_NOTICE, "tryAgainImage image loaded: " + tryAgainName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! tryAgainImage image already loaded: " + tryAgainName);
	
	if(!cantSeeImage2)
	{
		cantSeeImage2 = new ofImage();
		getManager()->loader->loadFromDisk(*cantSeeImage2, cantSeeName2);
		ofLog(OF_LOG_NOTICE, "cantSeeImage2 image loaded: " + cantSeeName2);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! cantSeeImage2 image already loaded: " + cantSeeName2);
	
	if(!helpImage) // large image do last
	{
		helpImage = new ofImage();
		getManager()->loader->loadFromDisk(*helpImage, helpImageName);
		ofLog(OF_LOG_NOTICE, "helpImage image loaded: " + helpImageName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! helpImage image already loaded: " + helpImageName);
	
	faces->load();
	faces->setup(getManager()->expressions->levelDifficulty);
	faces->start();
	
	
}

void GamePlay::unload()
{
	if(background)
	{
		//getManager()->loader->removeLoading(*backgroundName);
		ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
		background->unbind();
		delete background;
		background = NULL;
	}
	if(wellDone)
	{
		//getManager()->loader->removeLoading(*wellDoneName);
		ofLog(OF_LOG_NOTICE, "wellDone image unloaded: " + wellDoneName);
		wellDone->unbind();
		delete wellDone;
		wellDone = NULL;
	}
	
	if(tryAgainImage)
	{
		//getManager()->loader->removeLoading(*tryAgainName);
		ofLog(OF_LOG_NOTICE, "tryAgainImage image unloaded: " + tryAgainName);
		tryAgainImage->unbind();
		delete tryAgainImage;
		tryAgainImage = NULL;
	}
	if(tickImage)
	{
		//getManager()->loader->removeLoading(*tickName);
		ofLog(OF_LOG_NOTICE, "tickImage image unloaded: " + tickName);
		tickImage->unbind();
		delete tickImage;
		tickImage = NULL;
	}
	if(cantSeeImage2)
	{
		//getManager()->loader->removeLoading(*cantSeeName2);
		ofLog(OF_LOG_NOTICE, "cantSeeImage2 image unloaded: " + cantSeeName2);
		cantSeeImage2->unbind();
		delete cantSeeImage2;
		cantSeeImage2 = NULL;
	}

	if(helpImage)
	{
		//getManager()->loader->removeLoading(*helpImageName);
		ofLog(OF_LOG_NOTICE, "helpImage image unloaded: " + helpImageName);
		helpImage->unbind();
		delete helpImage;
		helpImage = NULL;
	}
	
	
	if(faces)
	{
		faces->unload();
	}
	
	
	unloadGUI();
	
}

void GamePlay::unloadGUI()
{
	soundOnButton->unload();
	soundOffButton->unload();
	musicOnButton->unload();
	musicOffButton->unload();
	nextFaceButton->unload();
	helpButton->unload();
}

void GamePlay::sceneWillAppear( ofxScene * fromScreen ){
	// reset our scene when we appear
	load();
	gameStats->resetRound(10);
	levelState = loading;
	
//	homeButton->setValue(true);
//	if(soundOn)
//		soundOnButton->setValue(true);
//	else
//		soundOffButton->setValue(true);
//	if(musicOn)
//		musicOnButton->setValue(true);
//	else
//		musicOffButton->setValue(true);
//	helpButton->setValue(true);

}

//scene notifications
void GamePlay::sceneWillDisappear( ofxScene * toScreen ){

}

void GamePlay::sceneDidAppear()
{
	levelState = intro;

	[getManager()->delegate performSelectorOnMainThread:@selector(gameStarted) withObject:nil waitUntilDone:NO];
    
	//getManager()->getScene(ABOUT)->unload();
	//getManager()->getScene(GAME_PLAY_MENU)->unload();
	gui->enable();
    soundPlayer.play();
	if(musicOn)
	{
		soundPlayer.setVolume(1);
	}
	else
		soundPlayer.setVolume(0);
	if(soundOn == false)
	{
		successPlayer.setVolume(0);
		wrongPlayer.setVolume(0);
		clickPlayer->setVolume(0);
		nCorrectPlayer.setVolume(0);
		nIncorrectPlayer.setVolume(0);
	}
	
}

void GamePlay::sceneDidDisappear( ofxScene * fromScreen )
{
	gui->disable();
	unload();
	//getManager()->expressions->stop();
    //soundPlayer.stop();
	soundPlayer.setVolume(0.0f);
}

void GamePlay::guiEvent(ofxUIEventArgs &e)
{
	if(levelState == endgame)
		return;
	
	if(hasLoaded() == false)
		return;
	
	string name = e.widget->getName();
	int kind = e.widget->getKind();
	
	if(getManager()->getCompletedFade() == true)
	{
		if(name == "homeButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->goToScene(OUTRO);
				levelState = endgame;
				[getManager()->delegate performSelectorOnMainThread:@selector(gameExit) withObject:nil waitUntilDone:NO];
				
				button->setValue(true);
#ifdef EXPRESSION_SAVE
				getManager()->expressions->saveExpression();
#endif
			}
			
		}
		else if(name == "helpButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				//getManager()->goToScene(MENU);
				button->setValue(true);
				
				helpOn = !helpOn;
				
				levelState = helpScreen;
				step = 0.0f;
				
			}
		}
		else if(name == "soundOnButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				button->setValue(true);
				faces->muteNarration = true;
				soundOn = false;
				successPlayer.setVolume(0);
				wrongPlayer.setVolume(0);
				clickPlayer->setVolume(0);
				nCorrectPlayer.setVolume(0);
				nIncorrectPlayer.setVolume(0);
				
				button->setVisible(false);
				soundOffButton->setVisible(true);
			
			}
		}
		else if(name == "soundOffButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				button->setValue(true);
				faces->muteNarration = false;
				soundOn = true;
				successPlayer.setVolume(0.6);
				wrongPlayer.setVolume(0.6);
				clickPlayer->setVolume(0.2f);
				nCorrectPlayer.setVolume(1);
				nIncorrectPlayer.setVolume(1);
				
				button->setVisible(false);
				soundOnButton->setVisible(true);
				
			}
		}
		else if(name == "musicOnButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				button->setValue(true);
				
				musicOn = false;
				soundPlayer.setVolume(0);
				
				button->setVisible(false);
				musicOffButton->setVisible(true);
				
			}
		}
		else if(name == "musicOffButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				button->setValue(true);
				
				musicOn = true;
				soundPlayer.setVolume(1);
				
				button->setVisible(false);
				musicOnButton->setVisible(true);
			}
		}
		else if(name == "nextFaceButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				button->setValue(true);
				
				step = 0.0f;
				levelState = skippedFace;

			}
		}
#ifdef EXPRESSION_SAVE
		else if(name == "addSample")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				if(levelState != correctFace && levelState != skippedFace && levelState != incorrectSkippedFace)
				{
					clickPlayer->play();
					
					getManager()->expressions->addGameSample(faces->current->expression);
				}
				button->setValue(true);
			}
		}
#endif
	}
}

void GamePlay::setGUI()
{
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING;
	float buttonWidth = ofGetWidth() / 3;
	float buttonWidth2 = ofGetWidth() / 2;
	float middle = ofGetWidth() / 2;
	float length = buttonWidth-xInit;
	float length2 = buttonWidth2-xInit;
	
	gui = new ofxUICanvas(this->getManager()->sharedGUI, ofGetWidth(), ofGetHeight());

	//gui->setFontSize(OFX_UI_FONT_LARGE, 15);
	//gui->setColorBack(ofColor(0,0,0));
	

	
//	correctLabel = new ofxUILabel( 0,65, 80, "0", OFX_UI_FONT_LARGE);
//	gui->addWidget(correctLabel);
//	correctLabel->setColorFill(ofColor(0,0,0));
//	correctLabel->setLabel("0");
	
	
	//ofxUILabel* expressionLabel = new ofxUILabel(middle-((length2-xInit)/2), ((ofGetHeight()/4)*2+(ofGetHeight()/4)), length2-xInit, "Current: None Found", //OFX_UI_FONT_LARGE);
	//getManager()->expressions->setLabel(expressionLabel);
	//gui->addWidget(expressionLabel);
	
	
	
	// Add GUI Elements for the bottom bar
	 
	int distance = 190;
	int height = 907;
	int widthO = 15;
	
	int soundX = widthO;
	int soundY = height;
	
	if(isRetina()) {
		
		distance = 380;
		height = 1814;
		widthO = 30;
		
		soundX = widthO;
		soundY = height;
		
//		soundOnButton = new ofxUISelfManagedImageButton(soundX, soundY, 340, 234,
//														true, "images/soundOnButton@2x.png","soundOnButton");
//		gui->addWidget(soundOnButton);
//		soundOnButton->setVisible(true);
//		
//		soundOffButton = new ofxUISelfManagedImageButton(soundX, soundY, 340, 234,
//														 true, "images/soundOffButton@2x.png","soundOffButton");
//		gui->addWidget(soundOffButton);
//		soundOffButton->setVisible(false);
//		
//		homeButton = new ofxUISelfManagedImageButton(soundX+distance, height, 340, 234,
//													 true, "images/homeButton.png@2x","homeButton");
//		homeButton->setSharedImg(getManager()->shared->homeButton);
//		gui->addWidget(homeButton);
//		
//		helpButton = new ofxUISelfManagedImageButton(soundX+distance*2, height, 340, 234,
//													 true, "images/helpButton@2x.png","helpButton");
//		gui->addWidget(helpButton);
//		
//		int musicX = soundX+distance*3;
//		int musicY = height;
//		
//		musicOnButton = new ofxUISelfManagedImageButton(musicX, musicY, 340, 234,
//														true, "images/musicOnButton@2x.png","musicOnButton");
//		gui->addWidget(musicOnButton);
//		musicOnButton->setVisible(true);
//		
//		musicOffButton = new ofxUISelfManagedImageButton(musicX, musicY, 340, 234,
//														 true, "images/musicOffButton@2x.png","musicOffButton");
//		gui->addWidget(musicOffButton);
//		musicOffButton->setVisible(false);
		
		// Add GUI elements for the Top next face
		nextFaceButton = new ofxUISelfManagedImageButton(1232, 32, 298, 220,
														 true, "images/nextFaceButton@2x.png","nextFaceButton");
		gui->addWidget(nextFaceButton);
		
#ifdef EXPRESSION_SAVE
		gui->addWidget(new ofxUIImageButton(60, 200, 298, 220,
											true, "images/nextFaceButton@2x.png","addSample"));
#endif
		
	} else {
	
//		//--------------------------- NON-Retina
//		soundOnButton = new ofxUISelfManagedImageButton(soundX, soundY, 170, 117,
//											 true, "images/soundOnButton.png","soundOnButton");
//		gui->addWidget(soundOnButton);
//		soundOnButton->setVisible(true);
//		
//		soundOffButton = new ofxUISelfManagedImageButton(soundX, soundY, 170, 117,
//											  true, "images/soundOffButton.png","soundOffButton");
//		gui->addWidget(soundOffButton);
//		soundOffButton->setVisible(false);
//
//		homeButton = new ofxUISelfManagedImageButton(soundX+distance, height, 170, 117,
//													 true, "images/homeButton.png","homeButton");
//		homeButton->setSharedImg(getManager()->shared->homeButton);
//		gui->addWidget(homeButton);
//		
//		helpButton = new ofxUISelfManagedImageButton(soundX+distance*2, height, 170, 117,
//													 true, "images/helpButton.png","helpButton");
//		gui->addWidget(helpButton);
//		
//		int musicX = soundX+distance*3;
//		int musicY = height;
//			
//		musicOnButton = new ofxUISelfManagedImageButton(musicX, musicY, 170, 117,
//											 true, "images/musicOnButton.png","musicOnButton");
//		gui->addWidget(musicOnButton);
//		musicOnButton->setVisible(true);
//		
//		musicOffButton = new ofxUISelfManagedImageButton(musicX, musicY, 170, 117,
//											  true, "images/musicOffButton.png","musicOffButton");
//		gui->addWidget(musicOffButton);
//		musicOffButton->setVisible(false);
		
		// Add GUI elements for the Top next face
		nextFaceButton = new ofxUISelfManagedImageButton(616, 16, 149, 110,
														 true, "images/nextFaceButton.png","nextFaceButton");
		gui->addWidget(nextFaceButton);

	#ifdef EXPRESSION_SAVE
		gui->addWidget(new ofxUIImageButton(30, 100, 149, 110,
											true, "images/nextFaceButton.png","addSample"));
	#endif
	
	}
	
	
	//gui->addWidget(new ofxUIFPS(ofGetWidth()/2-125, 10, OFX_UI_FONT_MEDIUM));
	
	gui->setAutoDraw(false);
	
	ofAddListener(gui->newGUIEvent,this,&GamePlay::guiEvent);
}

bool GamePlay::hasLoaded()
{
	// if all the images have loaded (buttons and background)
	if(
//	   soundOnButton->hasLoaded() &&
//	   soundOffButton->hasLoaded() &&
//	   musicOnButton->hasLoaded() &&
//	   musicOffButton->hasLoaded() &&
//		homeButton->hasLoaded() &&
	   nextFaceButton->hasLoaded() &&
	 
	   wellDone != NULL && wellDone->isAllocated() &&
	   background != NULL && background->isAllocated() &&
	   helpImage != NULL && helpImage->isAllocated() &&
	   tryAgainImage != NULL && tryAgainImage->isAllocated() &&
	   tickImage != NULL && tickImage->isAllocated() &&
	   cantSeeImage2 != NULL && cantSeeImage2->isAllocated() &&
	   faces->hasLoaded()
	   )
		return true;
	else
		return false;
}




