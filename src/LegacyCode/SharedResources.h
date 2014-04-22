#ifndef ofxSharedResources_h
#define ofxSharedResources_h

class SharedResources {
	
public:
	SharedResources() :homeButton(NULL)
	{
		//load();
	}
	~SharedResources()
	{
		unload();
	}
	
	void load()
	{
		//if(!clickPlayer)
		{
			clickPlayer = NULL;
			clickPlayer = new ofSoundPlayer();
			clickPlayer->setMultiPlay(true);
			clickPlayer->loadSound("sounds/click.wav");
			clickPlayer->setLoop(false);
			clickPlayer->setVolume(0.2f);
		}
		if(!homeButton)
		{
			homeButton = new ofImage();
			if(isRetina()) {
				homeButton->loadImage("images/homeButton@2x.png");
			} else {
				homeButton->loadImage("images/homeButton.png");
			}
			
		}
	};
	
	void unload()
	{
		if(clickPlayer)
		{
			clickPlayer->unloadSound();
			delete clickPlayer;
			clickPlayer = NULL;
		}
		if(homeButton)
		{
			delete homeButton;
			homeButton = NULL;
		}
	};

	
	ofSoundPlayer * clickPlayer;
	ofImage* homeButton;

};

#endif