//
//  ArmController.h
//  FishSet
//
//  Created by John Saba on 1/24/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"

@interface ArmController : CCNode

- (void)addCell:(GridCoord)cell;
- (void)removeCell:(GridCoord)cell;

@end
