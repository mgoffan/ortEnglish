//
//  ColoursLayer.h
//  ortEnglish
//
//  Created by Martin Goffan on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"

@interface ColoursLayer : CCLayer
{
    NSMutableArray *label, *layers;
    bool fill[3];
    bool hash[3][3];
}
+ (CCScene *)scene;

@end

@interface color : NSObject

@property int r, g, b;

@end
