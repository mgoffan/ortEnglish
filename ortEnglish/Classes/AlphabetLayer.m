//
//  AlphabetLayer.m
//  ortEnglish
//
//  Created by Martin Goffan on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlphabetLayer.h"
#import "MenuLayer.h"

@implementation AlphabetLayer


+ (CCScene *)scene {
    
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AlphabetLayer *layer = [AlphabetLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    
    if ( (self = [super init]) ) {
        CCSprite *bg = [CCSprite spriteWithFile:@"chalkboard_bg.png"];
        bg.position = ccp(160, 240);
        [self addChild:bg];
        
        NSMutableArray *numericValue = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *value = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 65; i < 91; i++) {
            [numericValue addObject:[NSString stringWithFormat:@"%c", (char)i]];
            [value addObject:[NSString stringWithFormat:@"%i",i]];
        }
        
        alphabet = [[NSDictionary alloc] initWithObjects:numericValue forKeys:value];
        
        int rnd[10] = {arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65, arc4random() % 26 + 65};
        
        for (int i = 0 ; i < 10; i++) {
            for (int j = 0 ; j < 10; j++) {
                bool a = true;
                while (a) {
                    if (i == j) {a = false; continue;}
                    if (rnd[i] == rnd[j])
                        rnd[i] = arc4random() % 26 + 65;
                    else a = false;
                }
            }
        }
        
        labels = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 10; i++) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:[alphabet objectForKey:[NSString stringWithFormat:@"%d", rnd[i]]]
                                                   fontName:@"Helvetica"
                                                   fontSize:30.0f];
            label.position = ccp(arc4random() % 280 + 30, arc4random() % 440 + 30);
            [self addChild:label];
            [labels addObject:label];
        }
        
        for (int i = 0 ; i < 10; i++) {
            for (int j = 0 ; j < 10; j++) {
                bool a = true;
                while (a) {
                    if (i == j) {a = false; continue;}
                    CCLabelTTF *l1 = [labels objectAtIndex:i];
                    CCLabelTTF *l2 = [labels objectAtIndex:j];
                    if (CGRectIntersectsRect(l1.boundingBox, l2.boundingBox))
                        l1.position = ccp(arc4random() % 280 + 30, arc4random() % 440 + 30);
                    else a = false;
                }
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(15, 430, 32, 32)];
        [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:45];
        [[[CCDirector sharedDirector] openGLView] addSubview:button];
        
        [button release];
        
        selected = [[NSMutableArray alloc] initWithCapacity:10];
        
        self.isTouchEnabled = YES;
    }
    
    return self;
}

int p = 0;

- (void)reset {
    [selected removeAllObjects];
    p = 0;
    for (CCLabelTTF *i in labels) {
        CCAction *action = [CCMoveTo actionWithDuration:2.0f position:ccp(arc4random() % 280 + 30, arc4random() % 440 + 30)];
        [i runAction:action];
    }
}

- (void)nose {
    [self removeChildByTag:123 cleanup:YES];
}

- (void)goBack {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:2.0f scene:[MenuLayer scene]]];
    
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:45] removeFromSuperview];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    for (CCLabelTTF *i in labels) {
        if (CGRectContainsPoint(i.boundingBox, point)) {
            CCAction *action = [CCMoveTo actionWithDuration:1.0f position:ccp(p * 30 + 30, 440)];
            p++;
            [i runAction:action];
            [selected addObject:i];
            if ([selected count] == 10) {
                
                int o[10], index = 0;
                
                for (CCLabelTTF *j in selected) {
                    NSString *key = [[alphabet allKeysForObject:j.string] objectAtIndex:0];
                    int n = [key intValue];
                    o[index] = n;
                    index++;
                }
                bool a = true; 
                for (int p = 0; p < 10; p++) {
                    if (p == 0) continue;
                    else {
                        if (o[p] < o[p - 1] && a) {
                            CCSprite *gameOver = [CCSprite spriteWithFile:@"hud.png"];
                            CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"It is wrong.\n Try Again." dimensions:CGSizeMake(210.0f, 60) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:18.0f];
                            float x = (([[CCDirector sharedDirector] winSize].width - label2.boundingBox.size.width) / 2) + (label2.boundingBox.size.width / 2);
                            float y = (gameOver.boundingBox.size.height- label2.boundingBox.size.height) / 2;
                            label2.position = ccp(x-55, y+25);
                            gameOver.position = ccp(160, 240);
                            [gameOver addChild:label2];
                            gameOver.opacity = 0;
                            gameOver.tag = 123;
                            CCAction *naction = [CCSequence actions: [CCFadeTo actionWithDuration:2.5f opacity:255], [CCDelayTime actionWithDuration:1.5f], [CCFadeTo actionWithDuration:2.5f opacity:0], [CCCallFunc actionWithTarget:self selector:@selector(nose)], nil];
                            [self addChild:gameOver z:20];
                            [gameOver runAction:naction];
                            
                            [self reset];
                            
                            a = false;
                        }
                    }
                    if (p == 9 && a) {
                        CCSprite *gameOver = [CCSprite spriteWithFile:@"hud.png"];
                        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Game Over. \n You did it OK" dimensions:CGSizeMake(210.0f, 60) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:18.0f];
                        float x = (([[CCDirector sharedDirector] winSize].width - label2.boundingBox.size.width) / 2) + (label2.boundingBox.size.width / 2);
                        float y = (gameOver.boundingBox.size.height- label2.boundingBox.size.height) / 2;
                        label2.position = ccp(x-55, y+25);
                        gameOver.position = ccp(160, 240);
                        [gameOver addChild:label2];
                        gameOver.opacity = 0;
                        CCAction *action = [CCFadeTo actionWithDuration:2.5f opacity:255];
                        [self addChild:gameOver z:20];
                        [gameOver runAction:action];
                        
                        CCAction *runAction = [CCSequence actions:[CCDelayTime actionWithDuration:5.0f], [CCCallFunc actionWithTarget:self selector:@selector(goBack)], nil];
                        [self runAction:runAction];
                    }
                }
            }
        }
    }
}

@end
