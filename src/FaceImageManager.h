//
//  FaceImageManager.h
//  CopyMe
//
//  Created by Daniel Rosser on 31/10/2013.
//
//

#ifndef CopyMe_FaceImageManager_h
#define CopyMe_FaceImageManager_h

#include "ofMain.h"
#include "ofSoundPlayer.h"
#include "Expressions.h"
#include "Globals.h"

#include "FaceImage.h"

#include "ofxThreadedImageLoader.h"

class FaceImages
{
public:
	FaceImages(ofxThreadedImageLoader* theLoader) : faceNumber(0), current(NULL), previous(NULL), next(NULL), afterNext(NULL), random(true), lastMax(1000), id(0), muteNarration(false), hasSetup(false)
	{
		loader = theLoader;
		
		
		// setup voice guides
        
        narrations.reserve(6);
		
		NarrationSound* narrationAnger = new NarrationSound("sounds/nangry.wav", ANGER);
		narrations.push_back(narrationAnger);
		
		NarrationSound* narrationDisgust = new NarrationSound("sounds/nyucky.wav", DISGUST);
		narrations.push_back(narrationDisgust);
		
		NarrationSound* narrationFear = new NarrationSound("sounds/nfear.wav", FEAR);
		narrations.push_back(narrationFear);
		
		NarrationSound* narrationJoy = new NarrationSound("sounds/nhappy.wav", JOY);
		narrations.push_back(narrationJoy);
		
		NarrationSound* narrationSad = new NarrationSound("sounds/nsad.wav", SADNESS);
		narrations.push_back(narrationSad);
		
		NarrationSound* narrationSurprise = new NarrationSound("sounds/nsurprise.wav", SURPRISE);
		narrations.push_back(narrationSurprise);
		
		// Setup the images for emotion descriptors
		
		descriptions.reserve(6);
		
		string angryText = "";
		string disgustText = "";
		string scaredText = "";
		string joyText = "";
		string sadText = "";
		string surpriseText = "";
		if(isRetina()) {
			angryText = "images/angrytext@2x.png";
			disgustText = "images/disgusttext@2x.png";
			scaredText = "images/scaredtext@2x.png";
			joyText = "images/joytext@2x.png";
			sadText = "images/sadtext@2x.png";
			surpriseText = "images/surprisetext@2x.png";
			
		} else {
			angryText = "images/angrytext.png";
			disgustText = "images/disgusttext.png";
			scaredText = "images/scaredtext.png";
			joyText = "images/joytext.png";
			sadText = "images/sadtext.png";
			surpriseText = "images/surprisetext.png";
		}
		
		
		DescriptionImage* descAnger = new DescriptionImage(angryText, ANGER);
		descriptions.push_back(descAnger);
		
		DescriptionImage* descDisgust = new DescriptionImage(disgustText, DISGUST);
		descriptions.push_back(descDisgust);
		
		DescriptionImage* descFear = new DescriptionImage(scaredText, FEAR);
		descriptions.push_back(descFear);
		
		DescriptionImage* descJoy = new DescriptionImage(joyText, JOY);
		descriptions.push_back(descJoy);
		
		DescriptionImage* descSad = new DescriptionImage(sadText, SADNESS);
		descriptions.push_back(descSad);
		
		DescriptionImage* descSurprise = new DescriptionImage(surpriseText, SURPRISE);
		descriptions.push_back(descSurprise);
		
		lastLevelDifficulty = easy;
	}
	~FaceImages()
	{
		// clean up the images
		for(int i=images.size()-1;i>=0;i--) //go through them
        {
			delete images[i]; //delete them
			images[i] = NULL;
            images.erase(images.begin()+i); // remove them from the vector
        }
		// clean up the descriptions
		for(int i=descriptions.size()-1;i>=0;i--) //go through them
        {
			delete descriptions[i]; //delete them
			descriptions[i] = NULL;
            descriptions.erase(descriptions.begin()+i); // remove them from the vector
        }
		// clean up narrations
		for(int i=narrations.size()-1;i>=0;i--) //go through them
        {
			delete narrations[i]; //delete them
			narrations[i] = NULL;
            narrations.erase(narrations.begin()+i); // remove them from the vector
        }
		
	}
	
	void load()
	{
		// load descriptions images
		if(descriptions.size() > 0)
		{
			for(int i=descriptions.size()-1;i>=0;i--) //go through them
			{
				if(descriptions[i])
					descriptions[i]->load(loader);
			}
		}
	};
	
	void setup(LevelDifficultly levelDifficulty)
	{
		
		if(hasSetup == false)
		{
			id = 0;
			// reserve memory
			if(levelDifficulty == easy)
				images.reserve(6);
			else if(levelDifficulty == medium)
				images.reserve(12);
			else if(levelDifficulty == hard)
				images.reserve(18);
			
			// Setup the Pictures of faces
			if(levelDifficulty == easy)
				setupEasy();
			else if(levelDifficulty == medium)
				setupMedium();
			else if(levelDifficulty == hard)
				setupHard();
			
			lastLevelDifficulty = levelDifficulty;
			hasSetup = true;
			
		}
		
		//std::random_shuffle(images.begin(), images.end());
		
		//else
		//std::random_shuffle(images.begin(), images.end()); // else just shuffle them around
	};
	
	void setupEasy()
	{
		string joy1 = "";
		string joy2 = "";
		string joy3  = "";
		string sad1 = "";
		string sad2 = "";
		string sad3 = "";
		if(isRetina()) {
			joy1 = "faces/joy1@2x.jpg";
			joy2 = "faces/joy2@2x.jpg";
			joy3 = "faces/joy3@2x.jpg";
			sad1 = "faces/sad1@2x.jpg";
			sad2 = "faces/sad2@2x.jpg";
			sad3 = "faces/sad3@2x.jpg";
			
		} else {
			joy1 = "faces/joy1.jpg";
			joy2 = "faces/joy2.jpg";
			joy3 = "faces/joy3.jpg";
			sad1 = "faces/sad1.jpg";
			sad2 = "faces/sad2.jpg";
			sad3 = "faces/sad3.jpg";
		}
		// Joy
		FaceImage* faceJoy1 = new FaceImage(joy1, JOY, id++);
		images.push_back(faceJoy1);
		
		FaceImage* faceJoy2 = new FaceImage(joy2, JOY, id++);
		images.push_back(faceJoy2);
		
		FaceImage* faceJoy3 = new FaceImage(joy3, JOY, id++);
		images.push_back(faceJoy3);
		
		// Sad
		
		FaceImage* faceSadness1 = new FaceImage(sad1, SADNESS, id++);
		images.push_back(faceSadness1);
		
		FaceImage* faceSadness2 = new FaceImage(sad2, SADNESS, id++);
		images.push_back(faceSadness2);
		
		FaceImage* faceSadness3 = new FaceImage(sad3, SADNESS, id++);
		images.push_back(faceSadness3);
	};
	
	void setupMedium()
	{
		setupEasy(); // Happy and sad
		
		string surprise1 = "";
		string surprise2 = "";
		string surprise3 = "";
		string angry1 = "";
		string angry2 = "";
		string angry3 = "";
		if(isRetina()) {
			surprise1 = "faces/surprise1@2x.jpg";
			surprise2 = "faces/surprise2@2x.jpg";
			surprise3 = "faces/surprise3@2x.jpg";
			angry1 = "faces/angry1@2x.jpg";
			angry2 = "faces/angry2@2x.jpg";
			angry3 = "faces/angry3@2x.jpg";
			
		} else {
			surprise1 = "faces/surprise1.jpg";
			surprise2 = "faces/surprise2.jpg";
			surprise3 = "faces/surprise3.jpg";
			angry1 = "faces/angry1.jpg";
			angry2 = "faces/angry2.jpg";
			angry3 = "faces/angry3.jpg";
		}
		
		// Surprised
		FaceImage* faceSurprise1 = new FaceImage(surprise1, SURPRISE, id++);
		images.push_back(faceSurprise1);
		
		FaceImage* faceSurprise2 = new FaceImage(surprise2, SURPRISE, id++);
		images.push_back(faceSurprise2);
		
		FaceImage* faceSurprise3 = new FaceImage(surprise3, SURPRISE, id++);
		images.push_back(faceSurprise3);
		
		// Angry
		FaceImage* faceAnger1 = new FaceImage(angry1, ANGER, id++);
		images.push_back(faceAnger1);
		
		FaceImage* faceAnger2 = new FaceImage(angry2, ANGER, id++);
		images.push_back(faceAnger2);
		
		FaceImage* faceAnger3 = new FaceImage(angry3, ANGER, id++);
		images.push_back(faceAnger3);
	};
	
	void setupHard()
	{
		setupEasy(); // Happy and sad
		setupMedium(); // Surpised and angry
		
		string fear1 = "";
		string fear2 = "";
		string fear3  = "";
		string disgust1 = "";
		string disgust2 = "";
		string disgust3 = "";
		if(isRetina()) {
			fear1 = "faces/fear1@2x.jpg";
			fear2 = "faces/fear2@2x.jpg";
			fear3 = "faces/fear3@2x.jpg";
			disgust1 = "faces/disgust1@2x.jpg";
			disgust2 = "faces/disgust2@2x.jpg";
			disgust3 = "faces/disgust3@2x.jpg";
			
		} else {
			fear1 = "faces/fear1.jpg";
			fear2 = "faces/fear2.jpg";
			fear3 = "faces/fear3.jpg";
			disgust1 = "faces/disgust1.jpg";
			disgust2 = "faces/disgust2.jpg";
			disgust3 = "faces/disgust3.jpg";
		}
		
		// Fear
		FaceImage* faceFear1 = new FaceImage(fear1, FEAR, id++);
		images.push_back(faceFear1);
		
		FaceImage* faceFear2 = new FaceImage(fear2, FEAR, id++);
		images.push_back(faceFear2);
		
		FaceImage* faceFear3 = new FaceImage(fear3, FEAR, id++);
		images.push_back(faceFear3);
		
		
		// Digust
		FaceImage* faceDisgust1 = new FaceImage(disgust1, DISGUST, id++);
		images.push_back(faceDisgust1);
		
		FaceImage* faceDisgust2 = new FaceImage(disgust2, DISGUST, id++);
		images.push_back(faceDisgust2);
		
		FaceImage* faceDisgust3 = new FaceImage(disgust3, DISGUST, id++);
		images.push_back(faceDisgust3);
		
	};
	
	void update()
	{
		
	};
	
	void draw()
	{
		if(current)
		{
			// Draw the current picture image
			if(isRetina()) {
				current->draw(32, 530, 720, 960);
				// Draw the description text down the bottom
				descriptions[(int)current->expression]->draw(370, 1574);
			} else {
				current->draw(16, 265, 360, 480);
				// Draw the description text down the bottom
				descriptions[(int)current->expression]->draw(185, 776+11);
			}
			
			
		}
	};
	
	void start()
	{
		if(random)
			startRandom();
		else
		{
			getNext();
			getNext();
			getNext();
		}
	};
    
    // Dan's random function for randomising next face photo
	
	void startRandom()
	{
		current = images[(int)ofRandom(0, images.size()-1)];
		current->load(loader);
		current->hasBeenShown();
		previous = current;
		
		bool valid = false;
		do
		{
			int theNext = (int)ofRandom(0, images.size()-1);
			if(theNext != (int)current->getID())
			{
				afterNext = images[theNext];
				afterNext->load(loader);
				afterNext->hasBeenShown();
				valid = true;
			}
			
		} while(valid == false);
		
		valid = false;
		do
		{
			int theNext = (int)ofRandom(0, images.size()-1);
			if(theNext != (int)current->getID() && theNext != (int)afterNext->getID())
			{
				next = images[theNext];
				next->load(loader);
				next->hasBeenShown();
				valid = true;
			}
			
		} while(valid == false);
	};
	
	FaceImage* getCurrent()
	{
		return current;
	};
	
	void getNext()
	{
		if(random)
			getRandomNext();
		else
		{
			if(previous)
				previous->unload();
			previous = current;
			current = next;
			next = afterNext;
			afterNext = images[faceNumber++];
			//afterNext->load();
			afterNext->load(loader);
			
			if(faceNumber == images.size()-1)
				faceNumber = 0;
		}
	};
	
	void getRandomNext()
	{
		bool valid = false;
		bool overrideNext = false;
		
		int avg = 0;
		int min = lastMax;
		int theMin = 0;
		int theMax = 0;
		int max = 0;
		for(int i = 0; i < images.size()-1; i++)
		{
			if(min >= images[i]->getShown())
			{	min = images[i]->getShown();
				theMin = i;
			}
			if(images[i]->getShown() >= max)
			{	max = images[i]->getShown();
				theMax = i;
			}
			avg += images[i]->getShown();
		}
		lastMax = max;
		int totalAvg = (int)(avg/images.size());
		int difference = totalAvg - min;
		//ofLog(OF_LOG_NOTICE, "min: " + ofToString(min) + " max: " + ofToString(max) + " tAvg: " + ofToString(totalAvg));
		if(difference >= 1)
		{	overrideNext = true;
			ofLog(OF_LOG_NOTICE, "override: " + images[theMin]->imageName + " min: " + ofToString(min) );
		}
		int tries = 0;
		do
		{
			tries++;
			int theNext = (int)ofRandom(0, images.size()-1);
			if(overrideNext)
				theNext = theMin;
			
			if((theNext != current->getID()
				&& theNext != next->getID()
				&& theNext != previous->getID()
				&& theNext != afterNext->getID()))
			{
				if(images[theNext]->getShown() <= (totalAvg+1) || tries >= 10)
				{
					//ofLog(OF_LOG_NOTICE, "theNext: " + ofToString(theNext) + " prev: " + ofToString(previous->getID()) + " cur: " + ofToString(current->getID()) + " next: " + ofToString(next->getID()) + " aNext: " + ofToString(afterNext->getID()));
					if(tries >= 10)
						ofLog(OF_LOG_NOTICE, "tries > max: " + ofToString(tries) );
					if(previous)
						previous->unload();
					previous = current;
					current = next;
					//current->hasBeenShown();
					next = afterNext;
					afterNext = images[theNext];
					afterNext->load(loader);
					afterNext->hasBeenShown();
					valid = true;
					
				}
			}
			else if(overrideNext)
			{
				overrideNext = false;
			}
			
			
			
			
		} while(valid == false);
	};
	
	void playNarration()
	{
		if(muteNarration)
			return;
		
		if(current)
			narrations[(int)current->expression]->play();
	};
	
	bool hasLoaded()
	{
		if(descriptions.size() > 0)
		{
			for(int i=descriptions.size()-1;i>=0;i--) //go through them
			{
				if(!descriptions[i]->hasLoaded())
					return false;
			}
		}
		// has all the face images loaded?
		if(current && current->hasLoaded() &&
		   next && next->hasLoaded() &&
		   afterNext && afterNext->hasLoaded()
		   )
			return true;
		else
			return false;
	};
	
	void unload()
	{
		hasSetup = false;
		// unload images
		if(images.size() > 0)
		{
			// clean up the images
			for(int i=images.size()-1;i>=0;i--) //go through them
			{
				delete images[i]; //delete them
				images[i] = NULL;
				images.erase(images.begin()+i); // remove them from the vector
			}
			images.clear();
		}
		
		if(descriptions.size() > 0)
		{
			for(int i=descriptions.size()-1;i>=0;i--) //go through them
			{
				if(descriptions[i])
					descriptions[i]->unload();
			}
		}
	};
	
	int lastMax;
	
	FaceImage* current;
	FaceImage* previous;
	FaceImage* next;
	FaceImage* afterNext;
	
	vector<FaceImage*> images;
	vector<DescriptionImage*> descriptions;
	vector<NarrationSound*> narrations;
	
	ofxThreadedImageLoader* loader;  // pointer to the loader
	
	LevelDifficultly lastLevelDifficulty;
	
	
	int faceNumber;
	bool random;
	
	bool muteNarration;
	
	bool hasSetup;
	
	int id;
	
};

#endif
