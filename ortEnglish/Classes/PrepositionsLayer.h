//
//  PrepositionsLayer.h
//  ortEnglish
//
//  Created by Martin Goffan on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface PrepositionsLayer : CCLayer
{
    CCSprite *square;
    CCLabelTTF *prepLabel;
    CCSprite *line;
    NSArray *directions;
    int rndom[10], index;
}

+ (CCScene *)scene;

@end
