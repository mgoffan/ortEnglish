//
//  NumbersLayer.h
//  ortEnglish
//
//  Created by Martin Goffan on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface NumbersLayer : CCLayer
{
    NSMutableArray *numbers, *dragLabels;
    NSDictionary *numberToText;
    CCLabelTTF *numberLabel, *score, *steps;
    int rndom[10], count, points;
    bool touched;
}

+ (CCScene *) scene;

@end
