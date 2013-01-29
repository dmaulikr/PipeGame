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

// grid coordinate keys of cells blocking hand movement
@property (nonatomic, strong) NSMutableArray *cellsBlocked;

// hand and arm 
@property (nonatomic, strong) HandController *handConroller;
@property (assign) GridCoord handEntryCoord;
@property (assign) GridCoord lastHandCell;

@property (nonatomic, strong) NSMutableDictionary *armUnits;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

// absolute position where the bottom left  of the grid begins
+ (CGPoint)sharedGridOrigin;







@end
