//
//  AppGlobals.h
//

#pragma once

static NSString * const kWebsiteURL = @"http://copyme.gamesstudio.org/";
static NSString * const kWebsiteSurvey = @"http://copyme.gamesstudio.org/survey.php";
static NSString * const kWebsitePrivacy = @"privacy.php";
static NSString * const kWebsiteTerms = @"legal.php";


// notification center strings
static NSString * const kNotifySelectedTheme = @"kNotifySelectedTheme";

static int kNavPaddingAreaPortrait = 64;//44;
static int kNavPaddingAreaLandscape = 32;//26;
static int kVideoSizeFullWidth = 509; //1018r;
static int kVideoSizeFullHeight = 286; //572r;

static float kTransitionTime = 0.3f;

typedef enum {
    RequestTypeUserRegistration = 0,
	RequestTypeScoreSubmission,
	RequestTypeOfflineScoreSubmission,
} RequestType;

// for the uiwebview
typedef enum {
    BrowserErrorHostNotFound = -1003,
    BrowserErrorOperationNotCompleted = -999,
    BrowserErrorNoInternetConnection = -1009
} BrowserErrorCode;
