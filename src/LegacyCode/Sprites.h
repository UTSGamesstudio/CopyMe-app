#ifndef GamePrototype_Sprites_h
#define GamePrototype_Sprites_h

#include "ofxSpriteSheetRenderer.h"

//create a new animation. This could be done optinally in your code andnot as a static, just by saying animation_t walkAnimation; walkAnimation.index =0, walkAnimation.frame=0 etc. I find this method the easiest though
static animation_t walkAnimation =
{	0,	/* .index			(int) - this is the index of the first animation frame. indicies start at 0 and go left to right, top to bottom by tileWidth on the spriteSheet		*/
	0,	/* .frame			(int) - this is the current frame. It's an internal variable and should always be set to 0 at init													*/
	1,	/* .totalframes		(int) - the animation length in frames																												*/
	1,	/* .width			(int) - the width of each animation frame in tiles																									*/
	1,	/* .height			(int) - the height of each animation frame in tiles	*/
    /**
     0,  // tex_y - how much offset from the top left of the sheet the texture is (no longer using the index for lookups)
     0,  // tex_x - doing it this way so that we can have differently sized textures
     1,  // tex_w -how big the texture is (on the sheet)
     1,  // tex_h
     
     0,   // sprite_x - how far offset the display of the sprite should be from the requested display position (how much alpha got trimmed when packing the sprite)
     0,   // sprite_y -
     1,   // spritesource_w - the size of the sprite before the alpha trimming took place
     1,   // spritesource_h - used for doing rotations around the center of the sprite (maybe, used for nothing for now)
     */
	500,	/* .frameduration	(unsigned int) - how many milliseconds each frame should be on screen. Less = faster																*/
	0,	/* .nexttick		(unsigned int) - the next time the frame should change. based on frame duration. This is an internal variable and should always be set to 0 at init	*/
	-1,	/* .loops			(int) - the number of loops to run. -1 equals infinite. This can be adjusted at runtime to pause animations, etc.									*/
	-1,	/* .finalindex		(int) - the index of the final tile to draw when the animation finishes. -1 is the default so total_frames-1 will be the last frame.				*/
	1	/* .frameskip		(int) - the incrementation of each frame. 1 should be set by default. If you wanted the animation to play backwards you could set this to -1, etc.	*/
};

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


//a quick and dirty sprite implementation
struct Sprite {
    string name;
    int id;
    int animationSpeed;
	animation_t animation;	// a variable to store the animation this sprite uses
    ExpressionList expression;
};





#endif
