#ifndef GamePrototype_ExpressionSystem_h
#define GamePrototype_ExpressionSystem_h

//#if TARGET_IPHONE_SIMULATOR
//	#warning *** Simulator mode: video code works only on a device
//	#undef NOT_IPAD_SIMULATOR
//#else
//	#define NOT_IPAD_SIMULATOR
//#endif

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "Globals.h"

//ON IPHONE NOTE INCLUDE THIS BEFORE ANYTHING ELSE
#include "ofxOpenCv.h"

#include <iostream>
#include <fstream>
#include <list>

#include "ofxFaceTrackerThreaded.h"
//#include "ofxFaceTracker.h"
#include "ofxXmlSettings.h"

using namespace ofxCv;
using namespace cv;

enum RenderState { RENDER = 0, SKIP = 1, SKIP2 = 2 };

class Expressions {
    
public:
    
    Expressions()
    {
        hasExited = false;
        imageScale = 2;
        type = CAM;
		trackerUpdate = FRAME;
		bool virtualSync = true;
		int frameRate = 30;
		int webcamID = 0;
		drawType = SPLINE;
		trackerReScale = 1.0;
		trackerIterations = 10;
		trackerClamp = 2.0;
		trackerTolerance = 0.01;
		trackerAttempts = 2;
		levelDifficulty = easy;
		
		toRender = RENDER;
		
		// Load Settings from XML file!
		if( XMLInput.loadFile("Settings.xml") )
			ofLog(OF_LOG_NOTICE, "Settings.xml loaded.");
		else
			ofLog(OF_LOG_FATAL_ERROR, "unable to load Settings.xml check data/ folder");
		
		
		// Logging settings
		bool append = false;
		if(XMLInput.getValue("settings:logging:logfile", "fail") == "append")
			append = true;
		else if(XMLInput.getValue("settings:logging:logfile", "fail") == "replace")
			append = false;
		// Logging to write to file
		if(XMLInput.getValue("settings:logging:output", "fail") == "logfile")
			ofLogToFile("DebugLog.txt", append);
		else if(XMLInput.getValue("settings:logging:output", "fail") == "console")
			
            
            
        // Set Webcam Device ID
        webcamID = (int)XMLInput.getValue("webcam:device", 1);
		
		// Input Type Setting
		if(XMLInput.getValue("input:type", "fail") == "video")
		{	type = VIDEO;
			ofLog(OF_LOG_NOTICE, "Attempting to use Video..."); }
		else if(XMLInput.getValue("input:type", "fail") == "batch")
		{	type = BATCH;
			ofLog(OF_LOG_NOTICE, "Attempting to use Video Batch..."); }
		else if(XMLInput.getValue("input:type", "fail") == "webcam")
		{	type = CAM;
			ofLog(OF_LOG_NOTICE, "Attempting to use Webcam..."); }
		else
			ofLog(OF_LOG_ERROR, "Error: <input><type> has not been set correctly. Reverting to Webcam.");
		
    	
#ifdef NOT_IPAD_SIMULATOR

		// Attempt to Activate Input Device (Webcam - Default fallback as well)
		if(type == CAM)
		{
			int x = 0;
			int y = 0;
			if(isRetina()) {
				x = 480;//(int)XMLInput.getValue("webcam:resolution:horizontal", 1024);
				y = 360; //(int)XMLInput.getValue("webcam:resolution:vertical",  768);
			} else {
				x = 480;//(int)XMLInput.getValue("webcam:resolution:horizontal", 1024);
				y = 360; //(int)XMLInput.getValue("webcam:resolution:vertical",  768);
				
			}
				//cam.setDesiredFrameRate(frameRate);
			cam.setDeviceID(webcamID);
            cam.setDesiredFrameRate(30);
			
			// Initialise
			if(cam.initGrabber(x, y))
			{
				//ofSetWindowShape(768, 1024);
				//tex.allocate(cam.getWidth(), cam.getHeight(), GL_RGB);
				//pix = new unsigned char[ (int)( cam.getWidth() * cam.getHeight() * 3.0) ];
				ofLog(OF_LOG_NOTICE, "Webcam Loaded: Streaming...");
				
			}
			else
			{	ofLog(OF_LOG_FATAL_ERROR, "Error: Could not load Webcam...");
				// Should throw exception here.
			}
		}
#endif
		
		// - UPDATE: cos want tracked data for every frame to be consistent
		// - FRAME: for performance without xperimental consideration
        if(XMLInput.getValue("tracker:update", "fail") == "step")
		{	trackerUpdate = CUSTOM_STEP;
			ofLog(OF_LOG_NOTICE, "Tracker: Analysing with step"); }
		else if(XMLInput.getValue("tracker:update", "fail") == "everyframe")
		{	trackerUpdate = FRAME;
			ofLog(OF_LOG_NOTICE, "Tracker: Analysing every frame"); }
		else if(XMLInput.getValue("tracker:update", "fail") == "everyupdate")
		{	trackerUpdate = UPDATE;
			ofLog(OF_LOG_NOTICE, "Tracker: Analysing every update"); }
		else
			ofLog(OF_LOG_ERROR, "Error: tracker:update has not been set correctly. Reverting to Default: Analysing every frame");
		
		
		if(XMLInput.getValue("tracker:view", "fail") == "spline")
		{	drawType = SPLINE;
			ofLog(OF_LOG_NOTICE, "Tracker: Display: Spline"); }
		else if(XMLInput.getValue("tracker:view", "fail") == "mesh")
		{	drawType = MESH;
			ofLog(OF_LOG_NOTICE, "Tracker: Display: Mesh");}
		else if(XMLInput.getValue("tracker:view", "fail") == "none")
		{	drawType = NONE;
			ofLog(OF_LOG_NOTICE, "Tracker: Display: None");}
		else
			ofLog(OF_LOG_ERROR, "Error: Tracker:Display has not been set correctly. Reverting to Default: Spline");
		
		float scale = XMLInput.getValue("tracker:rescale", 1.0);
		int iterations = XMLInput.getValue("tracker:iterations", 10);
		float clamp = XMLInput.getValue("tracker:clamp", 2.0);
		float tolerance = XMLInput.getValue("tracker:tolerance", 0.01);
		int attempts = XMLInput.getValue("tracker:attempts", 2);
        step = XMLInput.getValue("tracker:step", 1);
		
        
		ofLog(OF_LOG_NOTICE, "trackerReScale :\%f ", scale);
		ofLog(OF_LOG_NOTICE, "trackerIterations :\%i ", iterations);
		ofLog(OF_LOG_NOTICE, "trackerClamp :\%f ",  clamp);
		ofLog(OF_LOG_NOTICE, "trackerTolerance :\%f ", tolerance);
		ofLog(OF_LOG_NOTICE, "trackerAttempts :\%i ",  attempts);
		
		
		
		tracker.setRescale(scale);
		tracker.setIterations(iterations);
		tracker.setClamp(clamp);
		tracker.setTolerance(tolerance);
		tracker.setAttempts(attempts);
//		Poco::Thread& pocoThread =  tracker.getPocoThread();
//        pocoThread.setName("ofxFaceTrackerThreaded");
		tracker.setup();
		
#ifdef NOT_IPAD_SIMULATOR
		
		int w = cam.getWidth();
		int h = cam.getHeight();
		ofLog(OF_LOG_NOTICE, "cam width :\%i ", w);
		ofLog(OF_LOG_NOTICE, "cam height :\%i ", h);
#else
		int w = 0;
		int h = 0;
		if(isRetina()) {
			w = 360;//*2;
			h = 480;//*2;
		} else {
			w = 360;
			h = 480;
		}
#endif
		colorCv.allocate(w,h);
        colorCvSmall.allocate(w/imageScale,h/imageScale);
		
		// Load expressions
		classifier.load("expressions");
		
		// Setup default settings for classifier to add expressions to from the user
//		addedClassifier.addExpression("ANGER");
//        addedClassifier.addExpression("DISGUST");
//        addedClassifier.addExpression("FEAR");
//        addedClassifier.addExpression("JOY");
//        addedClassifier.addExpression("SADNESS");
//        addedClassifier.addExpression("SURPRISE");
        
        current = NO_EXPRESSION;
        setName(current);
		
	
        
    }
    
    void exit()
    {
        hasExited = true;
#ifdef NOT_IPAD_SIMULATOR
        if(type == CAM)
			cam.close();
#endif
	//	else if(type == VIDEO || type == BATCH)
	//		vid.close();
		
//		tracker.exit();
        if(tracker.isThreadRunning()) {
            tracker.waitForThread(true);
        }
    }
    
    ~Expressions()
    {
        if(hasExited == false) {
            exit();
        }
    }
    
	
	void startCamera() {
#ifdef NOT_IPAD_SIMULATOR
		cam.update();
		colorCv = cam.getPixels();
		colorCv.mirror(false, true);
		colorCvSmall.scaleIntoMe(colorCv, CV_INTER_NN);
#endif
	}
    
    
    // the thread function
    void update()
    {

                if(type == CAM)
                {

#ifdef NOT_IPAD_SIMULATOR
                    cam.update();
					
					if(cam.isFrameNew()) {
                        if(cam.getWidth()>=1) {
                            colorCv.setFromPixels(cam.getPixels(), cam.getWidth(), cam.getHeight());
                            colorCv.mirror(false, true);
                        }
					}
					
					if(toRender == RENDER) {
						if(cam.isFrameNew())
						{
	
							colorCvSmall.scaleIntoMe(colorCv, CV_INTER_NN);
							toRender = SKIP;
						}
					} else if(toRender == SKIP){
						toRender = SKIP2;
					} else {
						//colorCv.setFromPixels(cam.getPixels(), cam.getWidth(), cam.getHeight());
						toRender = RENDER;
					}
//                    colorCv = cam.getPixels();
					
#else
					//colorCv
#endif
                    
                    
                    
                    //colorLarge.scaleIntoMe(colorCv);
                    
                    //grayCv = colorCvSmall;
                    
                    // Perform tracker update and classification only when next frame has changed pixels
                    
                    if(trackerUpdate == CUSTOM_STEP)
                    {
                        timeSince += ofGetFrameRate()/1000;
                        if(timeSince >= step)
                        {
                            if(tracker.update(toCv(colorCvSmall)))
                                classifier.classify(tracker);
                            timeSince = 0.0f;
                        }
                    }
                    if((tracker.getFound() && trackerUpdate == CUSTOM_STEP && timeSince != 0.0)
                       || trackerUpdate == FRAME)
                    {
#ifdef NOT_IPAD_SIMULATOR
						if(cam.isFrameNew())
#endif
						{
							if(tracker.update(toCv(colorCvSmall)))
								classifier.classify(tracker);
						}
					}
                    else if(trackerUpdate == UPDATE)
                    {
						// ACTIVE
						if(tracker.update(toCv(colorCvSmall)))
							classifier.classify(tracker);
                    }
                    
                }
                
                if(drawType == MESH)
                {	rotationMatrix = tracker.getRotationMatrix();
                    scale = tracker.getScale();
                }
                
                if(tracker.getFound())
                {
                    int n = classifier.size();
                    int primary = classifier.getPrimaryExpression();
                    for(int i = 0; i < n; i++)
                    {
                        if(i == primary)
                        {
                            //classifier.getProbability(i) + .5;
                            string description = classifier.getDescription(i);
        
							if(description == "SURPRISE")
                                current = SURPRISE;
                            else if(description == "JOY")
                                current = JOY;
                            else if(description == "SADNESS")
                                current = SADNESS;
                            else if(description == "FEAR")
                                current = FEAR;
                            else if(description == "ANGER")
                                current = ANGER;
                            else if(description == "DISGUST")
                                current = DISGUST;
                            else if(description == "EYEBROWS")
                                current = EYEBROWS;
                            else if(description == "NEUTRAL")
                                current = NEUTRAL;
                            else
                                current = NO_EXPRESSION;
                        }
                    }
                    expressionTimeout = 0;
                    setName(current);
                }
                else
                {
                    expressionTimeout += ofGetFrameRate()/1000;
                    if(expressionTimeout >= 1.0f)
                    {	current = NO_EXPRESSION;
                        expressionTimeout = 0.0f;
                        setName(current);
                    }
                }
         
         
        
    };
    
    void draw()
    {
        
         ofSetColor(255, 255, 255, 128);
            
            if(type == CAM)
                colorCv.draw(ofGetWidth()/2, ofGetHeight()/2);
            //tex.draw(0, 0, tex.getWidth(), tex.getHeight());
            //cam.draw(0,0);
            //cam.draw(cam.getWidth()/2, cam.getHeight()/2);
            //tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
            
            
            if(tracker.getFound())
            {
                ofPushMatrix();
                ofTranslate(ofGetWidth()/2 - (colorCv.getWidth()/2), ofGetHeight()/2 - (colorCv.getHeight()/2));
                ofScale(imageScale, imageScale, imageScale);
                if(drawType == SPLINE)
                    tracker.draw();
                else if(drawType == MESH)
                {
                    ofSetLineWidth(1);
                    //tracker.draw();
                    tracker.getImageMesh().drawWireframe();
                    
                    ofPushView();
                    if(type == CAM)
                        ofSetupScreenOrtho(ofGetScreenWidth(), ofGetScreenHeight(), OF_ORIENTATION_UNKNOWN, true, -1000, 1000);
                    ofVec2f pos = tracker.getPosition();
                    ofTranslate(pos.x, pos.y);
                    applyMatrix(rotationMatrix);
                    ofScale(1,1,1);
                    ofDrawAxis(scale);
                    ofPopView();
                }
                ofPopMatrix();
                
                
                
                int w = 100, h = 12;
                ofPushStyle();
                ofPushMatrix();
                ofTranslate(5, 10);
                int n = classifier.size();
                int primary = classifier.getPrimaryExpression();
                for(int i = 0; i < n; i++)
                {
                    ofSetColor(i == primary ? ofColor::red : ofColor::black);
                    ofRect(0, 0, w * classifier.getProbability(i) + .5, h);
                    ofSetColor(255);
                    ofDrawBitmapString(classifier.getDescription(i), 5, 9);
                    ofTranslate(0, h + 5);
                }
                ofPopMatrix();
                ofPopStyle();
                
            }
            else
            {
                ofDrawBitmapString("Searching for face...", 10, 20);
            }
	
                 
    };
	
	
    void drawASD()
    {
        
		ofSetColor(255, 255, 255, 128);
		
		ofDisableAlphaBlending();
		
		if(type == CAM) {
			if(isRetina()) {
				colorCv.draw(784, 530, 360*2, 480*2);
			} else {
				colorCv.draw(360+32, 265);
			}
			
		}
		//tex.draw(0, 0, tex.getWidth(), tex.getHeight());
		//cam.draw(0,0);
		//cam.draw(cam.getWidth()/2, cam.getHeight()/2);
		//tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
		
		
		if(tracker.getFound())
		{
			ofPushMatrix();
			if(isRetina()) {
				ofTranslate(360*2+64,
							265*2);// + (colorCv.getHeight()/2));
				ofScale(imageScale*2, imageScale*2, imageScale*2);
			} else {
				ofTranslate(360+32,
							265);// + (colorCv.getHeight()/2));
				ofScale(imageScale, imageScale, imageScale);
			}
			
			if(drawType == SPLINE)
				tracker.draw();
			else if(drawType == MESH)
			{
				ofSetLineWidth(1);
				//tracker.draw();
				tracker.getImageMesh().drawWireframe();
				
				ofPushView();
				if(type == CAM)
					ofSetupScreenOrtho(ofGetScreenWidth(), ofGetScreenHeight(), OF_ORIENTATION_UNKNOWN, true, -1000, 1000);
				ofVec2f pos = tracker.getPosition();
				ofTranslate(pos.x, pos.y);
				applyMatrix(rotationMatrix);
				ofScale(1,1,1);
				ofDrawAxis(scale);
				ofPopView();
			}
			ofPopMatrix();
			
			
			/**
			int w = 100, h = 12;
			ofPushStyle();
			ofPushMatrix();
			ofTranslate(0, 768);
			int n = classifier.size();
			int primary = classifier.getPrimaryExpression();
			for(int i = 0; i < n; i++)
			{
				ofSetColor(i == primary ? ofColor::red : ofColor::black);
				ofRect(0, 0, w * classifier.getProbability(i) + .5, h);
				ofSetColor(255);
				ofDrawBitmapString(classifier.getDescription(i), 5, 9);
				ofTranslate(0, h + 5);
			}
			ofPopMatrix();
			ofPopStyle();
			 */
			
		}
		else
		{
			//ofPushMatrix();
			//ofTranslate(0, 768);
			//ofDrawBitmapString("Searching for face...", 10, 20);
			//ofPopMatrix();
		}
		
        
        
		
    };
	
	void drawGame()
    {
        
		ofSetColor(255, 255, 255, 128);
		
		if(type == CAM)
			colorCvSmall.draw(ofGetWidth()/2, ofGetHeight()/6);
		//tex.draw(0, 0, tex.getWidth(), tex.getHeight());
		//cam.draw(0,0);
		//cam.draw(cam.getWidth()/2, cam.getHeight()/2);
		//tex.draw(0, 0, tex.getWidth() / 4, tex.getHeight() / 4);
		
		
		if(tracker.getFound())
		{
			ofPushMatrix();
			ofTranslate(ofGetWidth()/2 - (colorCvSmall.getWidth()/2), ofGetHeight()/6 - (colorCvSmall.getHeight()/2));
			//ofScale(imageScale, imageScale, imageScale);
			if(drawType == SPLINE)
				tracker.draw();
			else if(drawType == MESH)
			{
				ofSetLineWidth(1);
				//tracker.draw();
				tracker.getImageMesh().drawWireframe();
				
				ofPushView();
				if(type == CAM)
					ofSetupScreenOrtho(ofGetScreenWidth(), ofGetScreenHeight(), OF_ORIENTATION_UNKNOWN, true, -1000, 1000);
				ofVec2f pos = tracker.getPosition();
				ofTranslate(pos.x, pos.y);
				applyMatrix(rotationMatrix);
				ofScale(1,1,1);
				ofDrawAxis(scale);
				ofPopView();
			}
			ofPopMatrix();
			
			
			
			int w = 100, h = 12;
			ofPushStyle();
			ofPushMatrix();
			ofTranslate(5, 10);
			int n = classifier.size();
			int primary = classifier.getPrimaryExpression();
			for(int i = 0; i < n; i++)
			{
				ofSetColor(i == primary ? ofColor::red : ofColor::black);
				ofRect(0, 0, w * classifier.getProbability(i) + .5, h);
				ofSetColor(255);
				ofDrawBitmapString(classifier.getDescription(i), 5, 9);
				ofTranslate(0, h + 5);
			}
			ofPopMatrix();
			ofPopStyle();
			
		}
		else
		{
			ofDrawBitmapString("Searching for face...", 10, 20);
		}
		
		
    };

    
    void reset()
    {
        tracker.reset();
		classifier.reset();
    };
    
    
    void addExpression()
    {
        classifier.addExpression();
    };
    
    void addExpression(string description)
    {
        classifier.addExpression(description);
    };
    
    void addSample()
    {
        classifier.addSample(tracker);
    };
//    void addSample(int id)
//    {
//        classifier.addSample(tracker, id);
//    };
//	
//    void addGameSample(int id)
//    {
//        classifier.addSample(tracker, id);
//		addedClassifier.addSample(tracker, id);
//    };
	
//    void saveExpression(string name = "expressions")
//	{
//        
//        // The follow code allows to save to the "Directory" for the app in iTunes. Allows to gain access to files created during runtime of the distributed app.
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        const char* dirString = [documentsDirectory cStringUsingEncoding:NSASCIIStringEncoding];
//        string dir = dirString;
//        ofDisableDataPath();
//        //classifier.save(name);
//        
//        //classifier.save(dir, "expressions");
//		addedClassifier.save(dir, "expressions");
//		
//		ofEnableDataPath();
//        
//	};
	
    void loadExpression(string name = "expressions")
    {
		classifier.load("expressions");
	};
    
    
    ExpressionList getExpression()
    {
        ExpressionList currentExpression = NO_EXPRESSION;
                   currentExpression = current;
            setName(currentExpression);
            //name += " ID: " + ofToString(currentExpression);
            //expressionLabel->setLabel(name);
      
        return currentExpression;
    };
    
    
protected:
    
    void setName(ExpressionList currentExpression)
    {
        name = "Your Expresssion: ";
        switch(currentExpression)
        {
            case 0:
                name += "Anger";
                break;
            case 1:
                name += "Disgust";
                break;
            case 2:
                name += "Fear";
                break;
            case 3:
                name += "Happy";
                break;
            case 4:
                name += "Sadness";
                break;
            case 5:
                name += "Surprise";
                break;
            case 6:
                name += "Raised Eyebrows";
                break;
            case 7:
                name += "Neutral";
                break;
            case 99:
                name += "None Found";
                break;
            default:
                name += "Not listed?";
                break;
                
        }
        
    };
    
private:
    
    string name;
    ExpressionList current;
	float expressionTimeout;
    float timeSince;
    
   // ofVideoPlayer vid;
#ifdef NOT_IPAD_SIMULATOR
	ofVideoGrabber cam;
#endif
	//ofxFaceTracker tracker;
	ofxFaceTrackerThreaded tracker;
	ExpressionClassifier classifier;
	//ExpressionClassifier addedClassifier;
    
	enum InputType { CAM, VIDEO, BATCH };
	enum TrackerUpdate { FRAME, UPDATE, CUSTOM_STEP };
	enum DrawType { SPLINE, MESH, NONE };
	
    
    string dataFileName;
    string participantName;
    string strBuffer;
    
    ofxXmlSettings XML;
	ofxXmlSettings XMLInput;
    ofFile file;
	std::string getTimeStamp(int ms);
	std::string timeOutput;
	
public:
	
	ofxCvColorImage colorCv;
    ofxCvColorImage colorCvSmall;
	LevelDifficultly levelDifficulty;
	
private:
    
    TrackerUpdate trackerUpdate;
    
    float trackerReScale;
    int trackerIterations;
    float trackerClamp;
    float trackerTolerance;
    int trackerAttempts;
    float step;
    
    InputType type;
	DrawType drawType;
	ofMatrix4x4 rotationMatrix;	
	float scale;
    
    //trying new image scale system
    int imageScale;
	
	RenderState toRender;
    bool hasExited;
	
    
    
};


#endif
