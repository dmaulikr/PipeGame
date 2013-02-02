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
#import "ArmNode.h"
#import "HandNode.h"
#import "GridUtils.h"
#import "TextureUtils.h"
#import "CellObjectLibrary.h"

static NSString *const kImageArmUnit = @"armUnit.png";


@implementation PuzzleLayer

+ (CCScene *)sceneWithPuzzle:(int)puzzle
{
    CCScene *scene = [CCScene node];
    
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithPuzzle:puzzle];
    [scene addChild:puzzleLayer];
       
    return scene;
}

- (id)initWithPuzzle:(int)puzzle 
{
    self = [super init];
    if (self) {

        [self setIsTouchEnabled:YES];
        
        _gridSize = [DataUtils puzzleSize:puzzle];
        _gridOrigin = [PuzzleLayer sharedGridOrigin];
        _cellsBlocked = [NSMutableArray array];
        
        // cell object library
        _cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];
        
        
        // hand
        _handConroller = [[HandNode alloc] initWithContentSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit)];
        _handEntryCoord = [DataUtils puzzleEntryCoord:puzzle];
        _handConroller.position = [GridUtils absolutePositionForGridCoord:_handEntryCoord unitSize:kSizeGridUnit origin:_gridOrigin];
        [self addChild:_handConroller];
        
        kDirection entryDirection = [DataUtils puzzleEntryDirection:puzzle];
        [_handConroller setDirectionFacing:entryDirection];
        _lastHandCell = _handEntryCoord;
        
        _handEntersFrom = [GridUtils oppositeDirection:entryDirection];
        
        // stack of arm nodes
        _armNodes = [NSMutableArray array];
    }
    return self;
}


#pragma mark - globals

+ (CGPoint)sharedGridOrigin
{
    return CGPointMake(100, 100);
}


#pragma mark - scene management

-(void) onEnterTransitionDidFinish
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}
-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}


# pragma mark - draw

- (void)draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
}


# pragma mark - targeted touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    
    // touch a cell to move to its position if path is free and in a line
    self.handConroller.moveToCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    self.handConroller.moveFromCell = self.handConroller.cell;
    
//    NSLog(@"move to cell: %i, %i; move from cell: %i, %i", self.handConroller.moveToCell.x, self.handConroller.moveToCell.y, self.handConroller.moveFromCell.x, self.handConroller.moveFromCell.y);

    
    if ([GridUtils isCell:self.handConroller.moveToCell equalToCell:self.handConroller.moveFromCell] == NO) {
        if ([self isLinearPathFreeBetweenStart:self.handConroller.moveFromCell end:self.handConroller.moveToCell]) {
            
            // arm units
            [GridUtils performBlockBetweenFirstCell:self.handConroller.moveFromCell secondCell:self.handConroller.moveToCell block:^(GridCoord cell, kDirection direction) {
                
                if ([GridUtils isCell:cell equalToCell:self.handConroller.moveToCell] == NO) {
                    [self addArmNodeAtCell:cell movingDirection:direction];
                }
            }];
            
            // hand sprite
            kDirection shouldFace = [GridUtils directionFromStart:self.handConroller.cell end:self.handConroller.moveToCell];
            [self.handConroller setDirectionFacing:shouldFace];
            self.handConroller.position = [GridUtils absolutePositionForGridCoord:self.handConroller.moveToCell unitSize:kSizeGridUnit origin:self.gridOrigin];            
        }
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}


#pragma mark - arm

- (void)addArmNodeAtCell:(GridCoord)cell movingDirection:(kDirection)direction
{  
    ArmNode *newArmNode;
    if ([self.armNodes count] > 0) {
        ArmNode *lastArmNode = [self.armNodes lastObject];
        kDirection firstExit = [GridUtils directionFromStart:cell end:[lastArmNode cell]];
        
//        NSLog(@"cell: %i, %i; last cell: %i, %i", cell.x, cell.y, [lastArmNode cell].x, [lastArmNode cell].y);
//        NSLog(@"first exit: %i", firstExit);
        
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:firstExit secondExit:direction];
    }
    else {
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:self.handEntersFrom secondExit:direction];
    }
    
    [self addChild:newArmNode];
    [self.armNodes addObject:newArmNode];
    [self.cellsBlocked addObject:[self objectKeyForCell:cell]];

}


#pragma mark - helpers

- (NSString *)objectKeyForCell:(GridCoord)cell
{
    return [NSString stringWithFormat:@"%i%i", cell.x, cell.y];
}

- (BOOL)isLinearPathFreeBetweenStart:(GridCoord)start end:(GridCoord)end
{
    // check one cell for blocked
    if ([self isCellBlocked:start]) {
        return NO;
    }
    // base case - if we reach the end of the path with no obstructions, it's a valid move
    if ([GridUtils isCell:start equalToCell:end]) {
        return YES;
    }
    
    // check for invalid direction
    kDirection direction = [GridUtils directionFromStart:start end:end];
    if (direction == kDirectionNone) {
        return NO;
    }
    // recursive call with next cell
    else {
        GridCoord newStart = [GridUtils stepInDirection:direction fromCell:start];
        return [self isLinearPathFreeBetweenStart:newStart end:end];
    }
}

- (BOOL)isCellBlocked:(GridCoord)cell
{
    NSString *key = [self objectKeyForCell:cell];
    for (NSString *storedKey in self.cellsBlocked) {
        if ([key isEqualToString:storedKey]) {
            return YES;
        }
    }
    return NO;
}


@end
