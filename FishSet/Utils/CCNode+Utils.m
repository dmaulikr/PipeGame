//
//  CCNode+Utils.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//
//

#import "CCNode+Utils.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"

@implementation CCNode (Utils)

- (GridCoord)cell
{
    return [GridUtils gridCoordForAbsolutePosition:self.position unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
}

@end
