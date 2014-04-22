#include "GameWeb.h"
#include "ofxScene.h"

//--------------------------------------------------------------
void GameWeb::setup()
{
	ofEnableSmoothing();
    
	ofBackground(0);
	backgroundName = "images/background.jpg";
	
	setGUI();
    gui->setDrawBack(false);
    gui->disable();
    gui->disableAppEventCallbacks();
	
	clickPlayer = getManager()->shared->clickPlayer;
	//clickPlayer.setMultiPlay(true);
	//clickPlayer.loadSound("sounds/click.wav");
	//clickPlayer.setLoop(false);
	//clickPlayer.setVolume(0.2f);
	
	//setupWeb();
	
	frameIndex = 0;
	
	inlineWebViewController.hideAnimated(false);
    
}

void GameWeb::setupWeb()
{
	ofBackground(127,127,127);
    doubleTapCount = 0;
	
    NSURL *url = [NSURL URLWithString:@"http://www.danoli3.com/cm/LimeSurvey/index.php/528547/lang-en"];
	
    inlineWebViewController.showAnimatedWithUrlAndFrameAndToolbar(NO, url, CGRectMake(50, 50, ofGetWidth()-100, ofGetHeight()-216), NO);
    ofAddListener(inlineWebViewController.event, this, &GameWeb::webViewEvent);
    
    //label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ofxiPhoneGetGLView().bounds.size.width, 40)];
   // label.center = CGPointMake(ofxiPhoneGetGLView().bounds.size.width / 2.0, ofxiPhoneGetGLView().bounds.size.height - 30);
    //label.text = @"Double tap to open fullscreen";
   // label.backgroundColor = [UIColor clearColor];
   //// label.textAlignment = UITextAlignmentCenter;
   // label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
   // [ofxiPhoneGetGLView() addSubview:label];
}

//--------------------------------------------------------------
void GameWeb::update(float dt)
{
	if(gui)
		gui->update();
}

//--------------------------------------------------------------
void GameWeb::draw()
{
	ofSetColor(255,255,255,255);
	ofDisableAlphaBlending();
	if(background)
		background->draw(0,0);
	gui->draw();
	
	
	
	
	
	if(webState == WEB_LOADING)
	{
		if(frameIndex < loading.getNumFrames()-1 )
			frameIndex++;
		else
			frameIndex = 0;
		
		loading.drawFrame(frameIndex, ofGetWidth()/2-(126/2), 14, 126, 22);
		//loading.drawFrame(frameIndex, ofGetWidth()/2-(220/2), 15, 220, 19);
		
	}
		//loading.drawFrame(frameIndex, 0, 0, 100, 100);

	
    ofSetRectMode(OF_RECTMODE_CORNER);
	
	
}

//--------------------------------------------------------------
void GameWeb::guiEvent(ofxUIEventArgs &e)
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
void GameWeb::exit()
{
	unload();
    gui->exit();
    if(gui)
    {	delete gui;
        gui = NULL;
    }
	
	clickPlayer = NULL;
}

void GameWeb::load()
{
	if(!background)
	{
		background = new ofImage();
		getManager()->loader->loadFromDisk(*background, backgroundName);
		ofLog(OF_LOG_NOTICE, "background image loaded: " + backgroundName);
		
	}
	else
		ofLog(OF_LOG_NOTICE, "! background image already loaded: " + backgroundName);
	
	bool success = dcd.decode("images/loader-1.gif");
	if (success) {
		loading = dcd.getFile();
	}
}

void GameWeb::unload()
{
	if(background)
	{
		//getManager()->loader->removeLoading(*backgroundName);
		ofLog(OF_LOG_NOTICE, "background image unloaded: " + backgroundName);
		background->unbind();
		delete background;
		background = NULL;
	}
	
	
	
}

//--------------------------------------------------------------
void GameWeb::windowResized(int w, int h)
{
    
}

//--------------------------------------------------------------
void GameWeb::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void GameWeb::dragEvent(ofDragInfo dragInfo){
    
}

//--------------------------------------------------------------
void GameWeb::webViewEvent(ofxiPhoneWebViewControllerEventArgs &args) {
    if(args.state == ofxiPhoneWebViewStateDidStartLoading){
        NSLog(@"Webview did start loading URL %@.", args.url);
		webState = WEB_LOADING;
    }
    else if(args.state == ofxiPhoneWebViewStateDidFinishLoading){
        NSLog(@"Webview did finish loading URL %@.", args.url);
		webState = WEB_LOADED;
    }
    else if(args.state == ofxiPhoneWebViewStateDidFailLoading){
        NSLog(@"Webview did fail to load the URL %@. Error: %@", args.url, args.error);
		webState = WEB_FAILED;
		inlineWebViewController.hideAnimated(false);
		NSString * htmlPath;
		htmlPath = ofxStringToNSString(ofToDataPath("html/404.html"));
		NSURL *url = [NSURL URLWithString:htmlPath];
		//inlineWebViewController.showAnimatedWithUrl(false, url);
		inlineWebViewController.showAnimatedWithUrlAndFrameAndToolbar(NO, url, CGRectMake(50, 50, ofGetWidth()-100, ofGetHeight()-216), NO);
		
    }
}

void GameWeb::setGUI()
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
	
	ofAddListener(gui->newGUIEvent,this,&GameWeb::guiEvent);
}

void GameWeb::sceneDidAppear()
{
    gui->enable();
	setupWeb();
	
}
void GameWeb::sceneDidDisappear( ofxScene * fromScreen )
{
    gui->disable();
	inlineWebViewController.hideAnimated(false);
	//unload();
}

void GameWeb::sceneWillAppear( ofxScene * fromScreen )
{
	load();
	homeButton->setValue(true);
}

void GameWeb::sceneWillDisappear( ofxScene * toScreen )
{
    
}

bool GameWeb::hasLoaded()
{
	// if all the images have loaded (buttons and background)
	if( homeButton->hasLoaded() &&
	   background != NULL && background->isAllocated()
	   )
		return true;
	else
		return false;
}
