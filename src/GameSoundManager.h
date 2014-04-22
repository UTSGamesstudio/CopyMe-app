
#pragma once

#include "ofxiOSSoundPlayer.h"

struct GameSound {
    ofxiOSSoundPlayer * sound;
    float volume;
};

class GameSoundManager {
    
public:
    
	static GameSoundManager * getInstance() {
		if(!_instance) {
			_instance = new GameSoundManager();
		}
        return _instance;
	};
    
    GameSoundManager();
    ~GameSoundManager();
    
    void destroy();
    void setup();
    void setMute(bool bMute);
	void setMuteMusic(bool bMute);
	void setIsSoundOn(bool isit);
    void fadeInAll();
    void fadeOutAll();
    void update();
    
    void playSound(string soundPath, float volume, bool bLoop=false);
    void playClickSound();
    void playMusic();
    void playIncorrectSound();
	void playTryAgainSound();
	void playCorrectSound();
	void playWellDoneSound();
	
    string pickRandomSound(vector<string> & soundNames);

    vector<GameSound> sounds;
	GameSound * music;
    
private:
    bool isSoundOn;
	bool isMusicOn;
    static GameSoundManager * _instance;
};
