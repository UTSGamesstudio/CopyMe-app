//
//  Globals.h
//  CopyMe_Globals
//
//  Created by Daniel Rosser on 2/06/13.
//
//

#ifndef CopyMe_Globals_h
#define CopyMe_Globals_h

#include "ofMain.h"

static int GLOBAL_SCALE = 1;

enum ExpressionList {
    ANGER = 0,
    DISGUST,
    FEAR,
    JOY,
    SADNESS,
    SURPRISE,
    EYEBROWS,
    NEUTRAL,
    NO_EXPRESSION = 99
    
};


enum LevelDifficultly {
	easy = 0,
	medium,
	hard
};


// Game Image locations
//static const string kBackgroundName = "images/background.png";
//static const string kBackgroundRetinaName = "images/background@2x.png";
//static const string kUIBoardBackgroundName = "images/ui_backBoard.png";
//static const string kUIBoardBackgroundRetinaName = "images/ui_backBoard@2x.png";
//static const string kUICompletenessName = "images/ui_completeness.png";
//static const string kUICompletenessRetinaName = "images/ui_completeness@2x.png";
//static const string kUITimeName = "images/ui_time.png";
//static const string kUITimeRetinaName = "images/ui_time@2x.png";
//static const string kUItempPlacerName = "images/ui_temp.png";
//static const string kUItempPlacerRetinaName = "images/ui_temp@2x.png";
//static const string kUIMiniFacesName = "images/ui_minifaces.png";
//static const string kUIMiniFacesRetinaName = "images/ui_minifaces@2x.png";
//static const string kUIMiniFacesBackgroundName = "images/ui_mini_background.png";
//static const string kUIMiniFacesBackgroundRetinaName = "images/ui_mini_background@2x.png";
//static const string kUIFaceBackgroundName = "images/ui_patternfade.png";
//static const string kUIFaceBackgroundRetinaName = "images/ui_patternfade@2x.png";



bool isRetina();
bool isRetina5();

#endif
