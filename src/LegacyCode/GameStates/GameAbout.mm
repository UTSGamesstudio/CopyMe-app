#include "GameAbout.h"
#include "ofxScene.h"

//--------------------------------------------------------------
void GameAbout::setup()
{
	ofEnableSmoothing();
    
	ofBackground(0);
	backgroundName = "images/aboutbg.jpg";
	
	setGUI();
    gui->setDrawBack(false);
    gui->disable();
    gui->disableAppEventCallbacks();
	
	clickPlayer = getManager()->shared->clickPlayer;
	//clickPlayer.setMultiPlay(true);
	//clickPlayer.loadSound("sounds/click.wav");
	//clickPlayer.setLoop(false);
	//clickPlayer.setVolume(0.2f);
    
}

//--------------------------------------------------------------
void GameAbout::update(float dt)
{
	if(gui)
		gui->update();
}

//--------------------------------------------------------------
void GameAbout::draw()
{
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	gui->draw();
    ofSetRectMode(OF_RECTMODE_CORNER);
}

//--------------------------------------------------------------
void GameAbout::guiEvent(ofxUIEventArgs &e)
{
    string name = e.widget->getName();
    int kind = e.widget->getKind();
    ofLog( OF_LOG_NOTICE,  "got event from: " + name);
    
    if(getManager()->getCompletedFade() == true)
    {
	
		if(name == "homeButton")
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
void GameAbout::exit()
{
	unload();
    gui->exit();
    if(gui)
    {	delete gui;
        gui = NULL;
    }
}

void GameAbout::load()
{
	if(!background)
	{
		background = new ofImage();
		getManager()->loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
}

void GameAbout::unload()
{
	if(background)
	{
		//getManager()->loader->removeLoading(backgroundName);
		ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
		background->unbind();
		delete background;
		background = NULL;
	}
	
}

//--------------------------------------------------------------
void GameAbout::windowResized(int w, int h)
{
    
}

//--------------------------------------------------------------
void GameAbout::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void GameAbout::dragEvent(ofDragInfo dragInfo){
    
}

void GameAbout::setGUI()
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
	
	homeButton = new ofxUISelfManagedImageButton(ofGetWidth()/2-(170/2), 905, 170, 117, true, "images/homeButton.png","homeButton");
	homeButton->setSharedImg(getManager()->shared->homeButton);
	gui->addWidget(homeButton);
	gui->setAutoDraw(false);
	
	ofAddListener(gui->newGUIEvent,this,&GameAbout::guiEvent);
}

void GameAbout::sceneDidAppear()
{
    gui->enable();
}
void GameAbout::sceneDidDisappear( ofxScene * fromScreen )
{
    gui->disable();
	//unload();
}

void GameAbout::sceneWillAppear( ofxScene * fromScreen )
{
	load();
	homeButton->setValue(true);
}

void GameAbout::sceneWillDisappear( ofxScene * toScreen )
{
    
}
