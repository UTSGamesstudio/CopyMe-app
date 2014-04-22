//
//  FaceImage.h
//  CopyMe
//
//  Created by Daniel Rosser on 31/10/2013.
//
//

#ifndef CopyMe_FaceImage_h
#define CopyMe_FaceImage_h

#include "ofMain.h"
#include "ofSoundPlayer.h"
#include "Expressions.h"
#include "Globals.h"
#include "ofxThreadedImageLoader.h"

class FaceImage {
	
public:
	
    FaceImage(string name, ExpressionList exp, int theID)
	:	shown(0),
	image(NULL),
	id(theID),
	timesCorrect(0),
	timesIncorrect(0),
	timesSkipped(0)
    {
		imageName = name;
        //Image.loadImage(imageName);
        expression = exp;
    }
	
	~FaceImage()
	{
		if(image)
		{
			ofLog(OF_LOG_NOTICE, "image loaded: " + imageName + " id: " + ofToString(id));
			image->unbind();
			delete image;
			image = NULL;
		}
	}
	
	void draw(int x, int y, int width, int height)
	{
		if(image)
		{
			if(image->isAllocated())
			{
				image->draw(x,y, width, height);
			}
		}
	};
	
	void load()
	{
		// not threaded loader
		if(!image)
		{
			//image->unbind();
			//delete image;
			//image = NULL;
			image = new ofImage();
			image->loadImage(imageName);
			ofLog(OF_LOG_NOTICE, "image loaded: " + imageName + " id: " + ofToString(id));
			
		}
		else
			ofLog(OF_LOG_NOTICE, "!image already loaded: " + imageName + " id: " + ofToString(id));
		
	};
	
	void load(ofxThreadedImageLoader* loader)
	{
		// using threaded loader
		if(!image)
		{
			//image->unbind();
			//delete image;
			//image = NULL;
			image = new ofImage();
			loader->loadFromDisk(*image, imageName);
			ofLog(OF_LOG_NOTICE, "image loaded: " + imageName + " id: " + ofToString(id));
			
		}
		else
			ofLog(OF_LOG_NOTICE, "!image already loaded: " + imageName + " id: " + ofToString(id));
		
		
	};
	
	void unload()
	{
		if(image)
		{
			ofLog(OF_LOG_NOTICE, "image unloaded: " + imageName + " id: " + ofToString(id));
			image->unbind();
			delete image;
			image = NULL;
		}
		
	};
	
	string getName() const
	{
		string name = "";
		switch(expression)
        {
            case 0:
                name += "angry.";
                break;
            case 1:
                name += "yucky.";
                break;
            case 2:
                name += "scared.";
                break;
            case 3:
                name += "happy.";
                break;
            case 4:
                name += "sad.";
                break;
            case 5:
                name += "surprised.";
                break;
            case 6:
                name += "Raised Eyebrows";
                break;
            case 7:
                name += "calm.";
                break;
            case 99:
                name += "None Found";
                break;
            default:
                name += "Not listed?";
                break;
                
        }
		return name;
	}
	
	bool hasLoaded()
	{
		if(image && image->isAllocated() && image->getWidth() > 0)
			return true;
		else
			return false;
	}
	
	void hasBeenShown()
	{
		shown++;
	};
	
	int getShown() const
	{
		return shown;
	};
	
	void incorrect()
	{
		timesIncorrect++;
	};
	
	void correct()
	{
		timesCorrect++;
	};
	
	void skipped()
	{
		timesSkipped++;
	};
	
	int getID() const
	{
		return id;
	}
	
	string imageName;
    ofImage* image;
    ExpressionList expression;
	
	// statistics tracking
private:
	int id;
	int shown;
	int timesCorrect;
	int timesIncorrect;
	int timesSkipped;
	
};



#endif
