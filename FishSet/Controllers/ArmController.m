//
//  ArmController.m
//  FishSet
//
//  Created by John Saba on 1/24/13.
//
//

#import "ArmController.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"


static NSString *const kImageArmUnit = @"armUnit.png";

@implementation ArmController

- (NSInteger)keyForCell:(GridCoord)cell
{
    return [[NSString stringWithFormat:@"%i%i", cell.x, cell.y] intValue];
}

- (void)addCell:(GridCoord)cell
{
    CCSprite *cellSprite = [CCSprite spriteWithFile:kImageArmUnit];
    cellSprite.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    [self addChild:cellSprite z:0 tag:[self keyForCell:cell]];
}

- (void)removeCell:(GridCoord)cell
{
    CCSprite *cellSprite = (CCSprite *)[self getChildByTag:[self keyForCell:cell]];
    if (cellSprite != nil) {
        [cellSprite removeFromParentAndCleanup:YES];
    }
}



@end
