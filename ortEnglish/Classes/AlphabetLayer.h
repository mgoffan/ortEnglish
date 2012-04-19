//
//  AlphabetLayer.h
//  ortEnglish
//
//  Created by Martin Goffan on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"

@interface AlphabetLayer : CCLayer
{
    NSDictionary *alphabet;
    NSMutableArray *labels, *selected;
}
+ (CCScene *)scene;

@end
