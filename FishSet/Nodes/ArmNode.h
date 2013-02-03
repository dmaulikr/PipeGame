//
//  ArmNode.h
//  FishSet
//
//  Created by John Saba on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellNode.h"
#import "GridUtils.h"

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

@interface ArmNode : CellNode

@property (nonatomic, strong) CCSprite *sprite;
    
- (id)initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit;

@end
