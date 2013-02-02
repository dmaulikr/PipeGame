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
#import "CCNode+Utils.h"

typedef enum
{
    kArmExitsNone = 0,
    kArmExitsDownLeft,
    kArmExitsDownRight,
    kArmExitsUpLeft,
    kArmExitsUpRight,
    kArmExitsDownUp,
    kArmExitsLeftRight,
} kArmExits;

@interface ArmNode : CCNode

@property (nonatomic, strong) CCSprite *sprite;
    
- (id)initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit;

@end
