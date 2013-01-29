//
//  PuzzleLayer.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "cocos2d.h"

#import "GridUtils.h"
@class HandController;
@class ArmController;

@interface PuzzleLayer : CCLayer

// grid
@property (assign) GridCoord gridSize;
@property (assign) CGPoint gridOrigin;

// game objects
@property (nonatomic, strong) HandController *handConroller;

// 
@property (assign) GridCoord handEntryCoord;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

// absolute position where the bottom left  of the grid begins
+ (CGPoint)sharedGridOrigin;


@end
