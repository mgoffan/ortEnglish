//
//  ColoursLayer.m
//  ortEnglish
//
//  Created by Martin Goffan on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColoursLayer.h"
#import "MenuLayer.h"

@implementation ColoursLayer

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ColoursLayer *layer = [ColoursLayer node];
	
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
        
        NSArray *col = [NSArray arrayWithObjects:@"Red", @"Orange", @"Yellow", @"Green", @"Blue", @"Violet", @"Brown", @"Black", @"White", nil];
        
        color *colores[9] = {[[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease], [[[color alloc] init] autorelease]};
        colores[0].r = 255; colores[0].g = 0;   colores[0].b = 0;
        colores[1].r = 255; colores[1].g = 128; colores[1].b = 0;
        colores[2].r = 255; colores[2].g = 255; colores[2].b = 0;
        colores[3].r = 0;   colores[3].g = 255; colores[3].b = 0;
        colores[4].r = 0;   colores[4].g = 0;   colores[4].b = 255;
        colores[5].r = 139; colores[5].g = 0;   colores[5].b = 139;
        colores[6].r = 153; colores[6].g = 102; colores[6].b = 0;
        colores[7].r = 0;   colores[7].g = 0;   colores[7].b = 0;
        colores[8].r = 255; colores[8].g = 255; colores[8].b = 255;
        
        NSDictionary *colours = [[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:
                                                         colores[0],
                                                         colores[1],
                                                         colores[2],
                                                         colores[3],
                                                         colores[4],
                                                         colores[5],
                                                         colores[6],
                                                         colores[7],
                                                         colores[8], nil]
                                                forKeys:col] autorelease];
        int rnd[3] = {arc4random() % 9, arc4random() % 9, arc4random() %9};
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (rnd[i] == rnd[j] && i != j) {
                    rnd[i] = arc4random() % 9;
                }
            }
        }
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (rnd[i] == rnd[j] && i != j) {
                    rnd[i] = arc4random() % 9;
                }
            }
        }
        
        
        CCLabelTTF *labels[3] = {[CCLabelTTF labelWithString:[col objectAtIndex:rnd[0]] fontName:@"Helvetica" fontSize:36.0f], [CCLabelTTF labelWithString:[col objectAtIndex:rnd[1]] fontName:@"Helvetica" fontSize:36.0f], [CCLabelTTF labelWithString:[col objectAtIndex:rnd[2]] fontName:@"Helvetica" fontSize:36.0f]};
        for (int i = 0; i < 3; i++){
            labels[i].position = ccp(120 + i * 40, 240 + i * 70);
            [self addChild:labels[i] z: i + 10];
        }
        label = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            labels[i].tag = i + 3;
            [label addObject:labels[i]];
        }
        
        CCLayerColor *layer[3] = {[CCLayerColor layerWithColor:ccc4([(color *)[colours objectForKey:labels[0].string] r], [(color *)[colours objectForKey:labels[0].string] g], [(color *)[colours objectForKey:labels[0].string] b], 255) width:200 height:40], [CCLayerColor layerWithColor:ccc4([(color *)[colours objectForKey:labels[1].string] r], [(color *)[colours objectForKey:labels[1].string] g], [(color *)[colours objectForKey:labels[1].string] b], 255) width:200 height:40], [CCLayerColor layerWithColor:ccc4([(color *)[colours objectForKey:labels[2].string] r], [(color *)[colours objectForKey:labels[2].string] g], [(color *)[colours objectForKey:labels[2].string] b], 255) width:200 height:40]};
        for (int i = 2; i >= 0; i--) {
            int a = (i == 2) ? 1 : (i == 1) ? 2 : 0;
            layer[a].position = ccp(20 + i * 40, 150 - i * 60);
            [self addChild:layer[i] z:i + 3];
        }
        layers = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            layer[i].tag = i+10;
            [layers addObject:layer[i]];
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(15, 430, 32, 32)];
        [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:45];
        [[[CCDirector sharedDirector] openGLView] addSubview:button];
        
        [button release];
        
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void)goBack {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:2.0f scene:[MenuLayer scene]]];
    
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:45] removeFromSuperview];
}

- (void) reset {
    hash[0][0] = hash[1][1] = hash[2][2] = false;
    fill[0] = fill[1] = fill[2] = false;
    
    for (int i = 2; i >= 0; i--) {
        int a = (i == 2) ? 1 : (i == 1) ? 2 : 0;
        [[layers objectAtIndex:a] setPosition:ccp(20 + i * 40, 150 - i * 60)];
    }
    
    for (int i = 0; i < 3; i++){
        [[label objectAtIndex:i] setPosition:ccp(120 + i * 40, 240 + i * 70)];
    }
}

- (void)nose {
    [self removeChildByTag:123 cleanup:YES];
}

- (void)corregir {
    if (hash[0][0] && hash[1][1] && hash [2][2]) {
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
    else {
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
        
        
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    for (CCLabelTTF *i in label) {
        if (CGRectContainsPoint(i.boundingBox, point)) {
            i.position = point;
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (CCLabelTTF *i in label) {
        for (CCLayerColor *j in layers) {
            if (CGRectIntersectsRect(i.boundingBox, j.boundingBox) && !fill[j.tag - 10]) {
                i.position = ccp(j.position.x + j.boundingBox.size.width / 2, j.position.y + j.boundingBox.size.height / 2);
                fill[j.tag - 10] = true;
                hash[[label indexOfObject:i]][[layers indexOfObject:j]] = true;
                if (fill[0] && fill[1] && fill [2]) {
                    [self corregir];
                }
            }
        }
    }
}

@end

@implementation color
@synthesize r, g, b;

@end
