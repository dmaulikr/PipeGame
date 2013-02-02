//
//  ArmNode.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GridUtils.h"

typedef enum
{
    kArmExitsDownLeft = 0,
    kArmExitsDownRight,
    kArmExitsUpLeft,
    kArmExitsUpRight,
    kArmExitsBottomTop,
    kArmExitsLeftRight,
} kArmExits;

@interface ArmNode : CCNode

@property (nonatomic, strong) CCSprite *sprite;
    
- (id)initWithTextureKey:(NSString *)key cell:(GridCoord)cell;

@end
