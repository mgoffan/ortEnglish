//
//  NumbersLayer.m
//  ortEnglish
//
//  Created by Martin Goffan on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumbersLayer.h"
#import "MenuLayer.h"

@implementation NumbersLayer

+ (CCScene *)scene {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NumbersLayer *layer = [NumbersLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (NSString *)getNewRandom {
    NSString *returnValue = [numbers objectAtIndex:rndom[count]];
    count++;
    return returnValue;
}

- (void)goBack {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:2.0f scene:[MenuLayer scene]]];
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:45] removeFromSuperview];
}

- (void)next {
    if (count-1 == 9) {
        CCSprite *gameOver = [CCSprite spriteWithFile:@"hud.png"];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Game Over.\n Your score was %d", points] dimensions:CGSizeMake(210.0f, 60) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:18.0f];
        float x = (([[CCDirector sharedDirector] winSize].width - label.boundingBox.size.width) / 2) + (label.boundingBox.size.width / 2);
        float y = (gameOver.boundingBox.size.height- label.boundingBox.size.height) / 2;
        label.position = ccp(x-55, y+25);
        gameOver.position = ccp(160, 240);
        [gameOver addChild:label];
        gameOver.opacity = 0;
        CCAction *action = [CCFadeTo actionWithDuration:2.5f opacity:255];
        [self addChild:gameOver];
        [gameOver runAction:action];
        
        CCAction *runAction = [CCSequence actions:[CCDelayTime actionWithDuration:5.0f], [CCCallFunc actionWithTarget:self selector:@selector(goBack)], nil];
        [self runAction:runAction];
    }
    else {
        [numberLabel setString:[self getNewRandom]];
        float x = (([[CCDirector sharedDirector] winSize].width - numberLabel.boundingBox.size.width) / 2) + (numberLabel.boundingBox.size.width / 2);
        numberLabel.position = ccp(x, 240);
        for (CCLabelTTF *i in dragLabels) {
            i.scale = 1;
        }
        points++;
        score.string = [NSString stringWithFormat:@"Score: %d", points];
        steps.string = [NSString stringWithFormat:@"%d/10", count];
    }
}

- (id)init {
    
    if ( (self = [super init]) ) {
        
        //Background
        CCSprite *sprite = [CCSprite spriteWithFile:@"chalkboard_bg.png"];
        sprite.position = ccp(160, 240);
        [self addChild:sprite];
        
        
        //Random order generator
        NSMutableArray *u = [[NSMutableArray alloc] init];
        
        for (unsigned int i = 0; i < 10; i++) {
            rndom[i] = i;
            [u addObject:[NSString  stringWithFormat:@"%d",i+1]];
        }
        
        for (unsigned int i = 0; i < 10; i++) {
            int r = i + (arc4random() % (10-i)); // Random remaining position.
            int temp = rndom[i];
            rndom[i] = rndom[r];
            rndom[r] = temp;
        }
        
        count = 0;
        points = 0;
        touched = false;
        numbers = [[[NSMutableArray alloc] initWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil] retain];
        
        
        numberToText = [[[NSDictionary alloc] initWithObjects:numbers forKeys:u] retain];
        [u release];
        
        numberLabel = [CCLabelTTF labelWithString:[self getNewRandom] fontName:@"Helvetica" fontSize:48.0f];
        int x = (([[CCDirector sharedDirector] winSize].width - numberLabel.boundingBox.size.width) / 2) + (numberLabel.boundingBox.size.width / 2);
        numberLabel.position = ccp(x, 240);
        [self addChild:numberLabel];
        
        dragLabels = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 10; i++) {
            CCLabelTTF *n = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",i]
                                               fontName:@"Helvetica" fontSize:32.0f];
            n.position = ccp((arc4random() % 290) + 20, (arc4random() % 420) + 30);
            [self addChild:n];
            [dragLabels addObject:n];
        }
        
        score = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:22.0f];
        score.position = ccp(60, 440);
        [self addChild:score];
        
        steps = [CCLabelTTF labelWithString:@"1/10" fontName:@"Helvetica" fontSize:22.0f];
        steps.position = ccp(280, 440);
        [self addChild:steps];
        
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

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    if (CGRectContainsPoint([numberLabel boundingBox], point)) {
        touched = true;
    }
    if (touched) {
        numberLabel.position = ccp(point.x, point.y);
//        numberLabel.scale = point.y / 1000 + 0.6;
        for (CCLabelTTF *i in dragLabels) {
            i.scale = 1;
            if (CGRectContainsPoint(i.boundingBox, point)) {
                i.scale = 3;
            }
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touched = false;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    
    int j = 1;
    for (CCLabelTTF *i in dragLabels) {
        if (CGRectContainsPoint(i.boundingBox, point)) {
            i.scale = 3;
            if ([[numberToText objectForKey:i.string] isEqualToString:numberLabel.string]) {
                [self next];
            }
            else {
                points--;
                score.string = [NSString stringWithFormat:@"Score: %d", points];
                numberLabel.position = ccp((([[CCDirector sharedDirector] winSize].width - numberLabel.boundingBox.size.width) / 2) + (numberLabel.boundingBox.size.width / 2), 240);
                i.scale = 1;
            }
        }
        j++;
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    touched = false;
}

@end
