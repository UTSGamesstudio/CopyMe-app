#ifndef OFXUI_SELF_MANAGED_IMAGE_BUTTON
#define OFXUI_SELF_MANAGED_IMAGE_BUTTON

#include "ofxUIWidget.h"

class ofxUISelfManagedImageButton : public ofxUIImageButton
{
public:
	ofxUISelfManagedImageButton() : img(NULL), shared(false) {}
    
    ofxUISelfManagedImageButton(float x, float y, float w, float h, bool _value, string _pathURL, string _name) : img(NULL) , shared(false) 
    {
        useReference = false;
        rect = new ofxUIRectangle(x,y,w,h);
        init(w, h, &_value, _pathURL, _name);
    }
	
    ofxUISelfManagedImageButton(float w, float h, bool _value, string _pathURL, string _name) : img(NULL) , shared(false) 
    {
        useReference = false;
        rect = new ofxUIRectangle(0,0,w,h);
        init(w, h, &_value, _pathURL, _name);
    }
	
   ofxUISelfManagedImageButton(float x, float y, float w, float h, bool *_value, string _pathURL, string _name) : img(NULL) , shared(false) 
    {
        useReference = true;
        rect = new ofxUIRectangle(x,y,w,h);
        init(w, h, _value, _pathURL, _name);
    }
    
    ofxUISelfManagedImageButton(float w, float h, bool *_value, string _pathURL, string _name) : img(NULL) , shared(false) 
    {
        useReference = true;
        rect = new ofxUIRectangle(0,0,w,h);
        init(w, h, _value, _pathURL, _name);
    }
    
    void init(float w, float h, bool *_value, string _pathURL, string _name)
    {
        name = string(_name);
		kind = OFX_UI_WIDGET_IMAGEBUTTON;
        
		paddedRect = new ofxUIRectangle(-padding, -padding, w+padding*2.0, h+padding*2.0);
		paddedRect->setParent(rect);
        
        if(useReference)
        {
            value = _value;
        }
        else
        {
            value = new bool();
            *value = *_value;
        }
        
        setValue(*_value);
        
		imageName = _pathURL;
        //img = new ofImage();
        //img->loadImage(_pathURL);
    }
	
	void load()
	{
		if(!img)
		{
			img = new ofImage();
			img->loadImage(imageName);
			//getManager()->loader->loadFromDisk(img, imageName);
			ofLog(OF_LOG_NOTICE, "GUI image loaded: " +imageName);
			
		}
		else
			ofLog(OF_LOG_NOTICE, "!GUI image already loaded: " + imageName);
	}
	
	void load(ofxThreadedImageLoader* loader)
	{
		if(!img)
		{
			img = new ofImage();
			loader->loadFromDisk(*img, imageName);
			ofLog(OF_LOG_NOTICE, "GUI image loaded: " +imageName);
			
		}
		else
			ofLog(OF_LOG_NOTICE, "!GUI image already loaded: " + imageName);
	}
	
	void unload()
	{
		if(img && shared == false)
		{
			delete img;
			img = NULL;
			ofLog(OF_LOG_NOTICE, "GUI image unloaded: " + imageName);

		}
	}
	
    virtual bool hasLabel()
    {
        return false;
    }
	
    virtual void setDrawPadding(bool _draw_padded_rect)
	{
		draw_padded_rect = _draw_padded_rect;
	}
    
    virtual void setDrawPaddingOutline(bool _draw_padded_rect_outline)
	{
		draw_padded_rect_outline = _draw_padded_rect_outline;
	}
    
    virtual ~ofxUISelfManagedImageButton()
    {
		unload();
    }
	
	
    virtual void drawBack()
    {
		
        if(draw_back)
        {
            ofFill();
            ofSetColor(color_back);
			if(img && img->isAllocated())
				img->draw(rect->getX(), rect->getY(), rect->getWidth(), rect->getHeight());
        }
    }
    
    virtual void drawFill()
    {
        if(draw_fill)
        {
            ofFill();
            ofSetColor(color_fill);
			if(img && img->isAllocated())
				img->draw(rect->getX(), rect->getY(), rect->getWidth(), rect->getHeight());
        }
    }
    
    virtual void drawFillHighlight()
    {
        if(draw_fill_highlight)
        {
            ofFill();
            ofSetColor(color_fill_highlight);
			if(img && img->isAllocated())
				img->draw(rect->getX(), rect->getY(), rect->getWidth(), rect->getHeight());
        }
    }
    
    virtual void drawOutlineHighlight()
    {
        if(draw_outline_highlight)
        {
            ofNoFill();
            ofSetColor(color_outline_highlight);
			if(img)
				img->draw(rect->getX(), rect->getY(), rect->getWidth(), rect->getHeight());
        }
    }
    
    void stateChange()
    {
        switch (state) {
            case OFX_UI_STATE_NORMAL:
            {
                draw_fill_highlight = false;
                draw_outline_highlight = false;
            }
                break;
            case OFX_UI_STATE_OVER:
            {
                draw_fill_highlight = false;
                draw_outline_highlight = true;
            }
                break;
            case OFX_UI_STATE_DOWN:
            {
                draw_fill_highlight = true;
                draw_outline_highlight = false;
            }
                break;
            case OFX_UI_STATE_SUSTAINED:
            {
                draw_fill_highlight = false;
                draw_outline_highlight = false;
            }
                break;
                
            default:
                break;
        }
    }
	
	void setParent(ofxUIWidget *_parent)
	{
		parent = _parent;
	}
	
    virtual void setValue(bool _value)
	{
		*value = _value;
        draw_fill = *value;
	}
    
    virtual void setVisible(bool _visible)
    {
        visible = _visible;
    }
	
	string imageName;
	
	void setSharedImg(ofImage* sharedImg)
	{
		img = sharedImg;
		shared = true;
	}
	
	virtual bool isHit(float x, float y)
    {
        if(visible)
        {
            return rect->inside(x, y);
        }
        else
        {
            return false;
        }
    }
	
	virtual bool hasLoaded()
	{
		if(img)
		{
			if(img->isAllocated())
			{
				return true;
			}
			else
				return false;
		}
		else
			return false;
	}
	
	
    
protected:    //inherited: ofxUIRectangle *rect; ofxUIWidget *parent;
    ofImage *img;
	bool shared;
	
	
	
};

#endif