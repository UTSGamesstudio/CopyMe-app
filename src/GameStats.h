#ifndef GamePrototype_GameStats_h
#define GamePrototype_GameStats_h

#include "ofMain.h"

class GameStats
{
public:
	GameStats() :
    	lives(1), score(0), progression(0), facesClicked(0), touches(0), timePlayed(0),
         allTimePlayed(0), showScore(true), showLives(true)//, scoreLabel(NULL), livesLabel(NULL)
    {
        
    }
    
    
    void update(float dt)
    {
        //if(showScore)
       // 	scoreLabel->setLabel("Score: " + ofToString(score));
       // if(showLives)
       // 	livesLabel->setLabel("Lives: " + ofToString(lives));
        
    }
    
    // Getters

    int getScore()
    { 
        return score;
    }
    
    int getLives()
    {
        return lives;
    }
    
    bool isDead()
    {
        if(lives <= 0)
            return true;
        else
            return false;
    }
    
    int getFacesClicked()
    {
        return facesClicked;
    }
    
    // Setters
    
    void LoadXML()
    {
        //
    }
    
    void SaveXML()
    {
        //
    }
    
    void resetRound(int l = 0, int s = 0)
    {
        // reset the round variables
        lives = l;
        score = s;
        
        facesClicked = 0;
        touches = 0;
        
        timePlayed = 0;
        
        
    }
    
    void setNewScore(int newScore)
    {
        score = newScore;
    }
    
    void addScore(int add)
    {
        score += add;
    }
    
    void negScore(int neg)
    {
        score -= neg;
    }
    
    void setNewLives(int newLives)
    {
        lives = newLives;
    }
    
    void addLives(int add)
    {
        lives += add;
    }
    
    void takeLife()
    {
        lives--;
    }    
    
    
    void negLives(int neg)
    {
        lives -= neg;
    }
    
    void hasClickedFace()
    {
        facesClicked++;
    }
    
    void hasTouched()
    {
        touches++;
    }
 /**
    void setScoreLabel(ofxUILabel* label)
    {
        scoreLabel = label;
        scoreLabel->setLabel("Score: " + ofToString(score));
    }
    
    void setLivesLabel(ofxUILabel* label)
    {
        livesLabel = label;       
        livesLabel->setLabel("Lives: " + ofToString(lives));
    }
    
    void setShowScore(bool show)
    {
        showScore = show;
        scoreLabel->setVisible(show);
    }
    
    void setShowLives(bool show)
    {
        showLives = show;
        livesLabel->setVisible(show);
    }
    */
    
private:
    int lives;
    int score;
    
    // general stat keeping per level
    int facesClicked;
    int touches;
    
    
    // globals @TODO    
    int progression;
    float timePlayed;
    float allTimePlayed;
    
    // UI
    
   // ofxUILabel* scoreLabel;
  //  ofxUILabel* livesLabel;
    bool showScore;
    bool showLives;

};

#endif
