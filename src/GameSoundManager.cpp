
#include "GameSoundManager.h"

GameSoundManager * GameSoundManager :: _instance = NULL;

GameSoundManager::GameSoundManager() {
	isSoundOn = true;
	isMusicOn = true;
	music = NULL;
}

GameSoundManager::~GameSoundManager() {
    
}

void GameSoundManager::destroy() {
	if(music) {
		music->sound->stop();
		music->sound->unloadSound();
		delete music->sound;
		delete music;
		music = NULL;
	}
    for(int i=0; i<sounds.size(); i++) {
		sounds[i].sound->stop();
		sounds[i].sound->unloadSound();
        delete sounds[i].sound;
    }
    sounds.clear();
}

void GameSoundManager::setup() {
	playMusic();
}

void GameSoundManager::setMuteMusic(bool bMute) {
	if(music){
		if(bMute) {
			isMusicOn = false;
            music->sound->setVolume(0);
        } else {
			isMusicOn = true;
            music->sound->setVolume(music->volume);
        }
	}
}

void GameSoundManager::setIsSoundOn(bool isit) {
	isSoundOn = isit;
	if(isit == true) {
		setMute(true);
	}
}

void GameSoundManager::setMute(bool bMute) {
    for(int i=0; i<sounds.size(); i++) {
        GameSound & sound = sounds[i];
        if(bMute) {
            sound.sound->setVolume(0);
        } else {
            sound.sound->setVolume(sound.volume);
        }
    }
}

void GameSoundManager::fadeInAll() {
    //
}

void GameSoundManager::fadeOutAll() {
    //
}

void GameSoundManager::update() {
    int i = 0;
    int t = sounds.size();
    for(i=0; i<t; i++) {
        GameSound & gameSound = sounds[i];
        ofxiOSSoundPlayer * sound = gameSound.sound;
        if(sound->getIsPlaying() == false) {
            delete sound;
            sounds.erase(sounds.begin() + i);
            --i;
            --t;
        }
    }
}

//--------------------------------------------------- play sound.
void GameSoundManager::playSound(string soundPath, float volume, bool bLoop) {
	if(isSoundOn) {
		sounds.push_back(GameSound());
		sounds.back().sound = new ofxiOSSoundPlayer();
		sounds.back().sound->loadSound(soundPath);
		sounds.back().sound->setVolume(sounds.back().volume = volume);
		sounds.back().sound->setLoop(bLoop);
		sounds.back().sound->play();
	}
}


void GameSoundManager::playClickSound() {
	if(isSoundOn) {
		playSound("sounds/click.wav", 0.2f);
	}
}
void GameSoundManager::playMusic() {
	if(music) {
		if(music->sound) {
		music->sound->stop();
		music->sound->unloadSound();
		delete music->sound;
		}
		delete music;
		music = NULL;
	}
	music = new GameSound();
	music->volume = 1.0;
	music->sound = new ofxiOSSoundPlayer();
	music->sound->loadSound("sounds/music.mp3");
	music->sound->setLoop(true);
	music->sound->setVolume(music->volume);
	music->sound->play();
}
void GameSoundManager::playIncorrectSound() {
	if(isSoundOn) {
		playSound("sounds/brightsound.wav", 0.6);
	}
}

void GameSoundManager::playTryAgainSound() {
	if(isSoundOn) {
		playSound("sounds/ntryagain.wav", 1.0);
	}
}
void GameSoundManager::playCorrectSound() {
	if(isSoundOn) {
		playSound("sounds/success.wav", 0.6);
	}
}
void GameSoundManager::playWellDoneSound() {
	if(isSoundOn) {
		playSound("sounds/nwelldone.wav", 1.0);
	}
}

string GameSoundManager::pickRandomSound(vector<string> & soundNames) {
    int soundIndex = ofRandom(soundNames.size());
	if(soundIndex == soundNames.size()){
		soundIndex = soundNames.size()-1;
	}
    string soundName = soundNames[soundIndex];
    soundNames.erase(soundNames.begin() + soundIndex);
    soundNames.push_back(soundName);
    return soundName;
}
