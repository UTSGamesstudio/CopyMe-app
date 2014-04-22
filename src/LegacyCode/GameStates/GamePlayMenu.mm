#include "GamePlayMenu.h"
#include "ofxScene.h"

// difficulty screen class

//--------------------------------------------------------------
void GamePlayMenu::setup()
{
	ofEnableSmoothing();
    
	ofBackground(0);
	backgroundName = "images/diffMenuBG.jpg";
	
	setGUI();
    gui->setDrawBack(false);
    gui->disable();
    gui->disableAppEventCallbacks();
	
	clickPlayer = (getManager()->shared->clickPlayer);
	//clickPlayer.setMultiPlay(true);
	//clickPlayer.loadSound("sounds/click.wav");
	//clickPlayer.setLoop(false);
	//clickPlayer.setVolume(0.2f);
    
}

//--------------------------------------------------------------
void GamePlayMenu::update(float dt)
{
    gui->update();
}

//--------------------------------------------------------------
void GamePlayMenu::draw()
{
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	gui->draw();
    ofSetRectMode(OF_RECTMODE_CORNER);
}

//--------------------------------------------------------------
void GamePlayMenu::guiEvent(ofxUIEventArgs &e)
{
    string name = e.widget->getName();
    int kind = e.widget->getKind();
    ofLog( OF_LOG_NOTICE,  "got event from: " + name);
    
    if(getManager()->getCompletedFade() == true)
    {
		if(name == "easyButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->expressions->levelDifficulty = easy;
				getManager()->getScene(GAME_PLAY)->load();
				getManager()->goToScene(GAME_PLAY);
				button->setValue(true);
			}
		}
		else if(name == "mediumButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->expressions->levelDifficulty = medium;
				getManager()->getScene(GAME_PLAY)->load();
				getManager()->goToScene(GAME_PLAY);
				button->setValue(true);
			}
		}
		else if(name == "hardButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();

				getManager()->expressions->levelDifficulty = hard;
				getManager()->getScene(GAME_PLAY)->load();
				getManager()->goToScene(GAME_PLAY);
				button->setValue(true);
			}
		}
		else if(name == "homeButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->goToScene(MENU);
				button->setValue(true);
			}
		}
		
        
        
    }
}

//--------------------------------------------------------------
void GamePlayMenu::exit()
{
	unload();
    gui->exit();
    if(gui)
    {	delete gui;
        gui = NULL;
    }
}

void GamePlayMenu::load()
{
	if(!background)
	{
		background = new ofImage();
		getManager()->loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	
	easyButton->load(getManager()->loader);
	mediumButton->load(getManager()->loader);
	hardButton->load(getManager()->loader);
}

void GamePlayMenu::unload()
{
	if(background)
	{
		ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
		background->unbind();
		delete background;
		background = NULL;
	}
	
	unloadGUI();
}

void GamePlayMenu::unloadGUI()
{
	easyButton->unload();
	mediumButton->unload();
	hardButton->unload();
}

//--------------------------------------------------------------
void GamePlayMenu::windowResized(int w, int h)
{
    
}

//--------------------------------------------------------------
void GamePlayMenu::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void GamePlayMenu::dragEvent(ofDragInfo dragInfo){
    
}

void GamePlayMenu::setGUI()
{
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING;
    float buttonWidth = ofGetWidth() / 3;
    float middle = ofGetWidth() / 2;
    float length = buttonWidth-xInit;
    float height = ofGetHeight() / 4;
	
    if(gui != NULL)
    {
        delete gui;
        gui = NULL;
    }
    
    gui = new ofxUICanvas(this->getManager()->sharedGUI, ofGetWidth(), ofGetHeight());
    
    //gui->addWidget(new ofxUIFPS(ofGetWidth()-150, 30, OFX_UI_FONT_MEDIUM));
	
	easyButton =  new ofxUISelfManagedImageButton(115, 35, 565, 210, true, "images/diff_easyButton.png", "easyButton");
    gui->addWidget(easyButton);
	
	mediumButton =  new ofxUISelfManagedImageButton(115, 315, 565, 210, true, "images/diff_mediumButton.png","mediumButton");
    gui->addWidget(mediumButton);
	
	hardButton =  new ofxUISelfManagedImageButton(115, 590, 565, 210, true, "images/diff_hardButton.png","hardButton");
    gui->addWidget(hardButton);
	
	homeButton = new ofxUISelfManagedImageButton(ofGetWidth()/2-(170/2), 905, 170, 117, true, "images/homeButton.png","homeButton");
	homeButton->setSharedImg(getManager()->shared->homeButton);
	gui->addWidget(homeButton);
	gui->setAutoDraw(false);
	
	ofAddListener(gui->newGUIEvent,this,&GamePlayMenu::guiEvent);
}

void GamePlayMenu::sceneDidAppear()
{
    gui->enable();
	
}
void GamePlayMenu::sceneDidDisappear( ofxScene * fromScreen )
{
    gui->disable();
}

void GamePlayMenu::sceneWillAppear( ofxScene * fromScreen )
{
	load();
	//getManager()->getScene(GAME_PLAY)->load();
	easyButton->setValue(true);
	mediumButton->setValue(true);
	hardButton->setValue(true);
	homeButton->setValue(true);
}

void GamePlayMenu::sceneWillDisappear( ofxScene * toScreen )
{
	if(toScreen->getSceneID() == GAME_PLAY)
	{
		unload();
		//getManager()->getScene(MENU)->unload();
	}
	//else if(toScreen->getSceneID() == MENU)
	//	getManager()->getScene(GAME_PLAY)->unload();
}

bool GamePlayMenu::hasLoaded()
{
	// if all the images have loaded (buttons and background)
	if(easyButton->hasLoaded() &&
	   mediumButton->hasLoaded() &&
	   hardButton->hasLoaded() &&
	   homeButton->hasLoaded() &&
	   background != NULL && background->isAllocated()
	   )
		return true;
	else
		return false;
}
