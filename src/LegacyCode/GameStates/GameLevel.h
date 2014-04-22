#ifndef GamePrototype_GameLevel_h
#define GamePrototype_GameLevel_h

#include "ofMain.h"
#include "ofxScene.h"

#include "ofxSpriteSheetRenderer.h"
#include "ofxBox2d.h"

#include "Sprites.h"
#include "GameObject.h"
#include "ObjectFactory.h"
#include "SelectedObject.h"

#include "ofxSceneManager.h"
#include "ofxUI.h"
#include "ExpressionSystem.h"
#include "Sprites.h"
//#include "HaarSystem.h"

#include "GameStats.h"

#include <iterator>


class GameLevel : public ofxScene{
		
	
	void setup(){  //load your scene 1 assets here...
        
        selectedObject = new SelectedObject();        
        gameStats = new GameStats();
        levelState = RUNNING;
       
        ofStyle style;
        style.color = ofColor(255);
        style.bgColor = ofColor(255);
        ofSetStyle(style);
		
        setGUI();
        gui->setDrawBack(false);
        gui->disable();
        gui->disableAppEventCallbacks();
               
        box2d.init();
        box2d.setGravity(0, 1);
        box2d.setFPS(30);
        box2d.registerGrabbing();
        box2d.createBounds(0, -256, ofGetWidth(), ofGetHeight()+256);
        box2d.setIterations(10, 10); // minimum for IOS
        //box2d.setIterations(30, 15); // minimum for IOS
        
        //int height = 50;
        //box2d.createGround(0, ofGetHeight()-height, ofGetWidth(), ofGetHeight()-height);
        
        // register the listener so that we get the events
        //ofAddListener(box2d.contactStartEvents, this, &GameLevel::contactStart);
       // ofAddListener(box2d.contactEndEvents, this, &GameLevel::contactEnd);
                 
        objectFactory = new ObjectFactory(100);
        objectFactory->box2d = &box2d;
         objectFactory->test2();
        //objectFactory->setup();       
        
               
                		
		ofEnableAlphaBlending(); // turn on alpha blending. important!
	};
    
    void contactStart(ofxBox2dContactArgs &e) {
        /**if(e.a != NULL && e.b != NULL) {
            
            // if we collide with the ground we do not
            // want to play a sound. this is how you do that
            if(e.a->GetType() == b2Shape::e_circle && e.b->GetType() == b2Shape::e_circle) {
               
                SoundData * aData = (SoundData*)e.a->GetBody()->GetUserData();
                SoundData * bData = (SoundData*)e.b->GetBody()->GetUserData();
                
                if(aData) {
                    aData->bHit = true;
                    sound[aData->soundID].play();
                }
                
                if(bData) {
                    bData->bHit = true;
                    sound[bData->soundID].play();
                }**/
          //  }
        //}
    }
    
    void exit() {       
        gui->exit();
        if(gui)
        {	delete gui;
            gui = NULL;
        }
        if(objectFactory)
        {
            objectFactory->cleanup();
            delete objectFactory;
            objectFactory = NULL;
        }
        if(selectedObject)
        {   delete selectedObject;
            selectedObject = NULL;
        }
        if(gameStats)
        {   delete gameStats;
            gameStats = NULL;
        }
		expressionSystem.stop();
        expressionSystem.exit();
		//haarSystem.stop();
        
    };
    
    //--------------------------------------------------------------
    void contactEnd(ofxBox2dContactArgs &e) {
        //if(e.a != NULL && e.b != NULL) {
            /**
            SoundData * aData = (SoundData*)e.a->GetBody()->GetUserData();
            SoundData * bData = (SoundData*)e.b->GetBody()->GetUserData();
            
            if(aData) {
                aData->bHit = false;
            }
            
            if(bData) {
                bData->bHit = false;
            }
             
             */
        //}
    }

	
	
	void update(float dt){ //update scene 1 here		
		
        /**
        ofVec2f gravity = ofxAccelerometer.getForce();
        gravity.y *= -1;
        gravity *= 30;
        box2d.setGravity(gravity);
         */
        box2d.update();
        objectFactory->update(dt);       
        selectedObject->update(dt);
        
        if(levelState == RUNNING)
        {
           
        
        ExpressionList foundExpression = expressionSystem.getExpression();
        if(selectedObject->hasSelectedObject())
        {
        	if(foundExpression == selectedObject->getExpression())
        	{
                gameStats->addScore(10);
            	objectFactory->destroy(selectedObject->getObject());            
            	selectedObject->reset();
                
        	}
        }
        
        if(foundExpression != NO_EXPRESSION)
        {
        
        	if((!gameStats->isDead()) && objectFactory->checkBottom())
        	{
            	gameStats->takeLife();
           	 	background += ofColor(20,0,0);
        	}
        	else if(gameStats->isDead())
       	 	{
            	background = ofColor(255,0,0);
                levelState = GAME_OVER;
        	}
        }
        
            /**
            if((!gameStats->isDead()) && objectFactory->checkFull())
        	{
            	gameStats->takeLife();
           	 	background += ofColor(20,0,0);
        	}
        	else if(gameStats->isDead())
       	 	{
            	background = ofColor(255,0,0);
                levelState = GAME_OVER;
        	}
             -*/

        }
        
        
        gameStats->update(dt);
        
        
        gui->update();
        
	};
	
	void draw(){ //draw scene 1 here
		        
        ofBackground(background);
        if(levelState == RUNNING)
        	expressionSystem.draw();
       // haarSystem.draw();
        objectFactory->draw();
        if(levelState == RUNNING)
        	selectedObject->draw();        
        gui->draw();       

	};
	
	//scene notifications
	void sceneWillAppear( ofxScene * fromScreen ){
        // reset our scene when we appear
        selectedObject->reset();
		expressionSystem.start();
        //haarSystem.start();
		gui->enable();
        
        gameStats->resetRound(10);
        levelState = RUNNING;       
        
        //objectFactory->test();
	};
	
	//scene notifications
	void sceneWillDisappear( ofxScene * toScreen ){
		
	};
    
    void sceneDidAppear()
    {
        
    };
    void sceneDidDisappear( ofxScene * fromScreen )
    {
        objectFactory->cleanup();
        gui->disable();
        expressionSystem.stop();
        //haarSystem.stop();
    };
       
        
    void touchDown(ofTouchEventArgs &touch){
        b2Body* touched = box2d.unproject(touch.x, touch.y);
        if(touched)
        {
        	Sprite* data = (Sprite*)touched->GetUserData();
            /**
        	cout << data->name << endl;
            if(touched->IsAwake())
            	touched->SetAwake(false);
            else
                touched->SetAwake(true);
            */
            
        	GameObject* obj = objectFactory->search(data->id);
            if(obj)
            {	selectedObject->setSelected(obj);
                gameStats->hasClickedFace();
            }
            else
                cout << "Was NULLLLLL";
            
            
            
        }
        else
        {
            selectedObject->reset();
            cout << "Nothing" << endl;
        }
        gameStats->hasTouched();
        
    };
    
    void guiEvent(ofxUIEventArgs &e)
    {
        string name = e.widget->getName();
        int kind = e.widget->getKind();
        cout << "got event from: " << name << endl;
        
        if(getManager()->getCompletedFade() == true)
        {
            if(name == "Menu")
            {
                // ofxUIButton *button = (ofxUIButton*) e.widget;
				
				////////////// @todo
                getManager()->goToScene(MENU);
                
            }                       
        }
    };
    
    void setGUI()
    {
        background = ofColor(32, 32, 32);
        float xInit = OFX_UI_GLOBAL_WIDGET_SPACING;
        float buttonWidth = ofGetWidth() / 3;
        float buttonWidth2 = ofGetWidth() / 2;
        float middle = ofGetWidth() / 2;
        float length = buttonWidth-xInit;
        float length2 = buttonWidth2-xInit;       
                     
        gui = new ofxUICanvas(this->getManager()->sharedGUI);
        //gui = new ofxUICanvas();
        
        ofxUILabel* selectedLabel = new ofxUILabel(middle-((length2-xInit)/2), ofGetHeight()/4, length2-xInit, selectedObject->getName(), OFX_UI_FONT_LARGE);
        selectedObject->setLabel(selectedLabel);
        gui->addWidget(selectedLabel);
        
        ofxUILabel* expressionLabel = new ofxUILabel(middle-((length2-xInit)/2), ((ofGetHeight()/4)*2+(ofGetHeight()/4)), length2-xInit, "Current: None Found", OFX_UI_FONT_LARGE);
        expressionSystem.setLabel(expressionLabel);
        gui->addWidget(expressionLabel);
        
        ofxUILabel* scoreLabel = new ofxUILabel(ofGetWidth()-220, 40, 250, "", OFX_UI_FONT_MEDIUM);
        gui->addWidget(scoreLabel);
        gameStats->setScoreLabel(scoreLabel);
        
        ofxUILabel* livesLabel = new ofxUILabel(ofGetWidth()-220, 60, 250, "", OFX_UI_FONT_MEDIUM);
        gui->addWidget(livesLabel);
        gameStats->setLivesLabel(livesLabel);
        
        //gui2->setTheme(OFX_UI_THEME_TEALTEAL);
        
        //gui->addWidget(new ofxUILabel(10, 30, "FFR - Game", OFX_UI_FONT_LARGE));
        gui->addWidget(new ofxUIFPS(ofGetWidth()-125, 10, OFX_UI_FONT_MEDIUM));
        
        gui->addWidget(new ofxUILabelButton(middle-((length-xInit)/2), 25, length-xInit, false, "Menu", OFX_UI_FONT_LARGE));
        
        
        ofAddListener(gui->newGUIEvent,this,&GameLevel::guiEvent);
    };	 
   
    enum LevelState { RUNNING = 0, GAME_OVER };
	
    LevelState levelState;
    ofColor 				  background;
	ofxBox2d                  box2d;	
    ObjectFactory*            objectFactory;
    SelectedObject*		      selectedObject;
	ExpressionSystem 		  expressionSystem;
	//HaarSystem				  haarSystem;
    
    GameStats*				  gameStats;
	
	
};

#endif
