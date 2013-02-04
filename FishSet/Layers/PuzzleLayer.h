//
//  PuzzleLayer.h
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"
@class HandNode;
@class ArmController;
@class CellObjectLibrary;

@interface PuzzleLayer : CCLayer

// grid
@property (assign) GridCoord gridSize;
@property (assign) CGPoint gridOrigin;

// list of game objects at each cell
@property (nonatomic, strong) CellObjectLibrary *cellObjectLibrary;

// hand and arm 
@property (nonatomic, strong) HandNode *handNode;
@property (assign) GridCoord handEntryCoord;
@property (assign) GridCoord lastHandCell;
@property (assign) kDirection handEntersFrom;

@property (nonatomic, strong) NSMutableArray *armNodes;

// touch
@property (assign) GridCoord cellFromLastTouch;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

// absolute position where the bottom left  of the grid begins
+ (CGPoint)sharedGridOrigin;







@end
