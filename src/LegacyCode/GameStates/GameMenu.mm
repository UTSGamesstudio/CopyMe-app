#include "GameMenu.h"
#include "ofxScene.h"

//--------------------------------------------------------------
void GameMenu::setup()
{
	ofEnableSmoothing();
    
	ofBackground(0);
	backgroundName = "images/main_MenuBG.jpg";
	
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
void GameMenu::update(float dt)
{ 
    gui->update();
}

//--------------------------------------------------------------
void GameMenu::draw()
{
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	gui->draw();
    ofSetRectMode(OF_RECTMODE_CORNER);
}

//--------------------------------------------------------------
void GameMenu::guiEvent(ofxUIEventArgs &e)
{
    string name = e.widget->getName();
    int kind = e.widget->getKind();
    ofLog( OF_LOG_NOTICE,  "got event from: " + name);
    
    if(getManager()->getCompletedFade() == true)
    {
		if(name == "playButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->goToScene(GAME_PLAY_MENU);
				button->setValue(true);
			}
			button->setValue(true);
		}
        else if(name == "aboutButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->goToScene(ABOUT);
				button->setValue(true);
			}
			button->setValue(true);
		}
		else if(name == "surveyButton")
		{
			ofxUIButton *button = (ofxUIButton*) e.widget;
			if(button->getValue() == false)
			{
				clickPlayer->play();
				getManager()->goToScene(SURVEY);
				button->setValue(true);
			}
			button->setValue(true);
		}
        
    }
}

//--------------------------------------------------------------
void GameMenu::exit()
{
    gui->exit();
	
	unload();
	
    if(gui)
    {	delete gui;
        gui = NULL;
    }
}

//--------------------------------------------------------------
void GameMenu::windowResized(int w, int h)
{    
    
}

//--------------------------------------------------------------
void GameMenu::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void GameMenu::dragEvent(ofDragInfo dragInfo){
    
}

void GameMenu::setGUI()
{	
       
    if(gui != NULL)
    {
        delete gui;
        gui = NULL;
    }
    
    gui = new ofxUICanvas(this->getManager()->sharedGUI, ofGetWidth(), ofGetHeight());
	gui->disableAppEventCallbacks();
    
    //gui->addWidget(new ofxUIFPS(ofGetWidth()-150, 30, OFX_UI_FONT_MEDIUM));
   
	playButton = new ofxUISelfManagedImageButton(155, 480, 479, 265, true, "images/main_playButton.png","playButton");
    gui->addWidget(playButton);
	
	aboutButton = new ofxUISelfManagedImageButton(159, 480+272, 470, 125, true, "images/main_aboutButton.png","aboutButton");
	gui->addWidget(aboutButton);
	
	surveyButton = new ofxUISelfManagedImageButton(159, 480+404, 470, 122, true, "images/main_surveyButton.png","surveyButton");
	gui->addWidget(surveyButton);
	gui->setAutoDraw(false);
    
	ofAddListener(gui->newGUIEvent,this,&GameMenu::guiEvent);
}

void GameMenu::load()
{
	if(!background)
	{
		background = new ofImage();
		getManager()->loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	
	playButton->load(getManager()->loader);
	aboutButton->load(getManager()->loader);
	surveyButton->load(getManager()->loader);
}
void GameMenu::loadNormal()
{
	if(!background)
	{
		background = new ofImage();
		background->loadImage(backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	
	playButton->load(getManager()->loader);
	aboutButton->load(getManager()->loader);
	surveyButton->load(getManager()->loader);
}

void GameMenu::unload()
{
		if(background)
		{
			//getManager()->loader->removeLoading(backgroundName);
			ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
			background->unbind();
			delete background;
			background = NULL;
		}
		
	unloadGUI();
}

void GameMenu::unloadGUI()
{
	//getManager()->loader->removeLoading(playButton->imageName);
	//getManager()->loader->removeLoading(aboutButton->imageName);
	playButton->unload();
	aboutButton->unload();
	surveyButton->unload();
	
}

void GameMenu::sceneDidAppear()
{
    
	
	getManager()->getScene(GAME_PLAY_MENU)->load();
	//getManager()->getScene(ABOUT)->load();
	
}
void GameMenu::sceneDidDisappear( ofxScene * fromScreen )
{
    gui->disable();
	
	unload();
	
}

void GameMenu::sceneWillAppear( ofxScene * fromScreen )
{
	load();
	gui->enable();
	playButton->setValue(true);
	aboutButton->setValue(true);
	surveyButton->setValue(true);
	
}

bool GameMenu::hasLoaded()
{
	// if all the images have loaded (buttons and background)
	if( playButton->hasLoaded() &&
		aboutButton->hasLoaded() &&
	    surveyButton->hasLoaded() &&
	    background != NULL && background->isAllocated()
	)
		return true;
	else
		return false;
}

void GameMenu::sceneWillDisappear( ofxScene * toScreen )
{
    
}
