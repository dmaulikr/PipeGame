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

// tilemap
@property (nonatomic, strong) CCTMXTiledMap *tileMap;
@property (nonatomic, strong) CCTMXMapInfo *mapInfo;

// list of game objects at each cell
@property (nonatomic, strong) CellObjectLibrary *cellObjectLibrary;

// hand and arm 
@property (nonatomic, strong) HandNode *handNode;
@property (nonatomic, strong) NSMutableArray *armNodes;
@property (assign) GridCoord handEntryCoord;
@property (assign) GridCoord lastHandCell;
@property (assign) kDirection handEntersFrom;
@property (assign) BOOL isHandNodeSelected;
@property (assign) int currentPipeLayerNumber;

// touch
@property (assign) GridCoord cellFromLastTouch;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

// absolute position where the bottom left  of the grid begins
+ (CGPoint)sharedGridOrigin;







@end
