//
//  PuzzleLayer.m
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "PuzzleLayer.h"

#import "GameConstants.h"
#import "DataUtils.h"

@implementation PuzzleLayer

+ (CCScene *)sceneWithPuzzle:(int)puzzle
{
    CCScene *scene = [CCScene node];
    
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithPuzzle:puzzle];
    [scene addChild:puzzleLayer];
       
    return scene;
}


-(id) initWithPuzzle:(int)puzzle 
{
    self = [super init];
    if (self) {
    
        _gridSize = [DataUtils puzzleSize:puzzle];
        _gridOrigin = CGPointMake(100, 100);
        
    }
    return self;
}

-(void) draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
}


@end
