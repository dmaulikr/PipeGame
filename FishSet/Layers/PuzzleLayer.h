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

@property (assign) GridCoord gridSize;
@property (assign) CGPoint gridOrigin;

@property (nonatomic, strong) HandController *handConroller;
@property (nonatomic, strong) ArmController *armController;
@property (assign) GridCoord handEntryCoord;

@property (assign) GridCoord moveTo;

// puzzles defined in Puzzles.plist
+ (CCScene *)sceneWithPuzzle:(int)puzzle;

+ (CGPoint)sharedGridOrigin;


@end
