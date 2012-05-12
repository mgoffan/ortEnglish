//
//  HelloWorldLayer.m
//  ortEnglish
//
//  Created by Martin Goffan on 4/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MenuLayer.h"
#import "NumbersLayer.h"
#import "ColoursLayer.h"
#import "AlphabetLayer.h"
#import "PrepositionsLayer.h"

// HelloWorldLayer implementation
@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) gotoNumbers {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0f scene:[NumbersLayer scene]]];
}

- (void)gotoColours {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0f scene:[ColoursLayer scene]]];
}

- (void)gotoAlphabet {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0f scene:[AlphabetLayer scene]]];
}

- (void)gotoPrepositions {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:2.0f scene:[PrepositionsLayer scene]]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CCSprite *layer = [CCSprite spriteWithFile:@"chalkboard_bg.png"];
        layer.position = ccp(160, 240);
        [self addChild:layer];
        
        CCSprite *logo  = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp(160, 380);
        logo.scaleX = 0.9;
        [self addChild:logo];
        
        
        CCMenuItem *menuItem = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:@"Numbers" fontName:@"MarkerFelt-Wide" fontSize:36.0f] target:self selector:@selector(gotoNumbers)];
        CCMenuItem *menuItem2 = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:@"Colours" fontName:@"MarkerFelt-Wide" fontSize:36.0f] target:self selector:@selector(gotoColours)];
        CCMenuItem *menuItem3 = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:@"Alphabet" fontName:@"MarkerFelt-Wide" fontSize:36.0f] target:self selector:@selector(gotoAlphabet)];
        CCMenuItem *menuItem4 = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:@"Prepositions" fontName:@"MarkerFelt-Wide" fontSize:36.0f] target:self selector:@selector(gotoPrepositions)];
        
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem, menuItem2, menuItem3, menuItem4, nil];
        [menu alignItemsVertically];
        
        [self addChild:menu];
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
