//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"

@interface CellNode : CCNode <CCTargetedTouchDelegate>

- (GridCoord)cell;
- (BOOL)shouldBlockMovement;

@end
