//
//  PuzzleLayer.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"

@interface PuzzleLayer : CCLayer

@property (assign) GridCoord gridSize;
@property (assign) CGPoint gridOrigin;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

@end
