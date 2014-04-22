//
//  Globals.cpp
//  CopyMe
//
//  Created by Daniel Rosser on 2/06/13.
//
//

#import <UIKit/UIKit.h>
#include "ofAppiOSWindow.h"
#include "Globals.h"


bool isRetina() {
    return ofAppiPhoneWindow::getInstance()->isRetinaEnabled();
}

bool isRetina5() {
    if(isRetina() == false) {
        return false;
    }
    return ([UIScreen mainScreen].bounds.size.height == 568);
}
