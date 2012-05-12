//
//  PrepositionsLayer.m
//  ortEnglish
//
//  Created by Martin Goffan on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrepositionsLayer.h"
#import "MenuLayer.h"

@implementation PrepositionsLayer

static NSString *sentence = @"The box is %@ the line.";

+ (CCScene *)scene {
    
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PrepositionsLayer *layer = [PrepositionsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)goBack {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:2.0f scene:[MenuLayer scene]]];
    
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:45] removeFromSuperview];
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:50] removeFromSuperview];
}

- (void)next {
    
    CGSize sq = square.boundingBox.size;
    CGSize li = line.boundingBox.size;
    CGPoint sqp = square.position;
    CGPoint lip = line.boundingBox.origin;
    
    
    NSLog(@"%d", index);
    
    NSString *c = [directions objectAtIndex:0];
    
    /// @"on", @"above", @"over", @"in front of", @"beside", @"below", @"under"
    
    if ([c isEqualToString:@"on"]) {
        NSLog(@"%@", NSStringFromCGPoint(lip));
        if (sqp.y - (lip.y + li.height) <= 20 &&
            sqp.y - (lip.y + li.height) >= 5 &&
            ( sqp.x >= lip.x || sqp.x <= lip.x + li.height ) ) {
            //Correcto
            NSLog(@"correcto");
        }
    }
    else if ([c isEqualToString:@"over"]) {
        
    }
    else if ([c isEqualToString:@"in front of"]) {
        
    }
    else if ([c isEqualToString:@"beside"]) {
        
    }
    else if ([c isEqualToString:@"below"]) {
        
    }
    else {
        
    }
    
    index++;
}

- (id)init {
    
    if ( ( self = [super init] ) ) {
        self.isTouchEnabled = YES;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"chalkboard_bg.png"];
        bg.position = ccp(160, 240);
        [self addChild:bg];
        
        UIImage *back = [UIImage imageNamed:@"back.png"];
        UIImage *forward = [UIImage imageWithCGImage:back.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored];
        
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(15, 430, 32, 32)];
        [button setImage:back forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:45];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame: CGRectMake(280, 430, 32, 32)];
        [button2 setImage:forward forState:UIControlStateNormal];
        [button2 setImage:forward forState:UIControlStateHighlighted];
        [button2 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [button2 setTag:50];
        
        [[[CCDirector sharedDirector] openGLView] addSubview:button2];
        [[[CCDirector sharedDirector] openGLView] addSubview:button];
        
        [button2 release];
        [button release];
        
        
        line = [CCSprite spriteWithFile:@"line.png"];
        line.position = ccp(160.0f, 220.0f);
        line.scaleX = 0.8f;
        [self addChild:line];
        
        square = [CCSprite node];
		[square setTextureRect:CGRectMake(130, 300, 64, 64)];
		[square setColor:ccWHITE];
		[square setOpacity:255];
        [square setPosition: ccp(160, 300)];
        
        [self addChild:square];
        
        directions = [[NSArray alloc] initWithObjects:@"on", @"above", @"over", @"in front of", @"beside", @"below", @"under", nil];
        
        for (int i = 0; i < 7; i++) rndom[i] = i;
        
        for (unsigned int i = 0; i < 7; i++) {
            int r = i + (arc4random() % (7-i)); // Random remaining position.
            int temp = rndom[i];
            rndom[i] = rndom[r];
            rndom[r] = temp;
        }
        
        index = 0;
        
        prepLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:sentence, [directions objectAtIndex:0]] dimensions:CGSizeMake(300.0f, 80.0f) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:36.0f];
        prepLabel.position = ccp(160.0f, 420.0f);
        [self addChild:prepLabel];
        
        index++;
        
        NSLog(@"%d", index);
    }
    
    return self;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if (CGRectContainsPoint(square.boundingBox, point)) {
        square.position = point;
    }
}

@end
