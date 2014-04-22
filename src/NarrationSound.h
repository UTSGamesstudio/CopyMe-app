//
//  NarrationSound.h
//  CopyMe
//
//  Created by Daniel Rosser on 30/10/2013.
//
//

#ifndef CopyMe_NarrationSound_h
#define CopyMe_NarrationSound_h

#include "ofMain.h"
#include "ofSoundPlayer.h"
#include "Expressions.h"
#include "Globals.h"

#include "GameSoundManager.h"

class NarrationSound {
public:
	NarrationSound(string name, ExpressionList exp)
    {
		soundName = name;
        load();
        expression = exp;
    }
	~NarrationSound()
	{
		unload();
	}
	
	void play()
	{
		GameSoundManager::getInstance()->playSound(soundName, 1.0);
	//	sound.play();
	}
	
	void load()
	{
	//	sound.loadSound(soundName);
	};
	
	void unload()
	{
	//	sound.unloadSound();
	};
	
	string soundName;
	//ofSoundPlayer sound;
    ExpressionList expression;
	
};

#endif
