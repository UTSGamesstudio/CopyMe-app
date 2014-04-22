//
//  DescriptionImage.h
//  CopyMe
//
//  Created by Daniel Rosser on 30/10/2013.
//
//

#ifndef CopyMe_DescriptionImage_h
#define CopyMe_DescriptionImage_h

#include "ofMain.h"
#include "ofSoundPlayer.h"
#include "Expressions.h"
#include "Globals.h"


class DescriptionImage {
public:
	DescriptionImage(string name, ExpressionList exp) : image(NULL)
    {
		imageName = name;
        expression = exp;
    }
	~DescriptionImage()
	{
		unload();
	}
	
	void draw(int x, int y)
	{
		if(image)
		{
			image->draw(x,y);
		}
	};
	
	void load(ofxThreadedImageLoader* theLoader)
	{
		if(!image)
		{
			image = new ofImage();
			theLoader->loadFromDisk(*image, imageName);
		}
	};
	
	void unload()
	{
		if(image)
		{
			delete image;
			image = NULL;
		}
	};
	
	bool hasLoaded()
	{
		if(image && image->isAllocated() && image->getWidth() > 0)
			return true;
		else
			return false;
	};
	
	string imageName;
	ofImage* image;
    ExpressionList expression;
	
};


#endif
