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
    kArmExitsDownThrough,
    kArmExitsUpThrough,
    kArmExitsLeftThrough,
    kArmExitsRightThrough
} kArmExits;

FOUNDATION_EXPORT NSString *const kPGNotificationArmNodeTouched;


@interface ArmNode : CellNode

@property (nonatomic, strong) CCSprite *sprite;
    
-(id) initInCell:(GridCoord)cell firstExit:(kDirection)firstExit secondExit:(kDirection)secondExit pipeLayer:(NSString *)pipeLayer;
-(id) initForLayerConnectionInCell:(GridCoord)cell exit:(kDirection)exit pipeLayer:(NSString *)pipeLayer;

@end
