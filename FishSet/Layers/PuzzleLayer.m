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
        
        
        // TODO: replace with cell object lib
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
    GridCoord touchCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    
    BOOL didHandleGridTouch = [self tryGridTouchAtPosition:touchPosition cell:touchCell];
    if (didHandleGridTouch) {
        return YES;
    }
    
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord touchCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    
    if ([GridUtils isCell:self.cellFromLastTouch equalToCell:touchCell] == NO) {
        self.cellFromLastTouch = touchCell;
        [self tryGridTouchAtPosition:touchPosition cell:touchCell];
    }  
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}

#pragma mark - handle grid touch

- (BOOL)tryGridTouchAtPosition:(CGPoint)touchPosition cell:(GridCoord)touchCell
{
    // handle for touch within grid
    if ([GridUtils isCellInBounds:touchCell gridSize:self.gridSize]) {
        

        // touch a cell to move to its position if path is free and in a line
        GridCoord moveToCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
        
        if ([GridUtils isCell:moveToCell equalToCell:self.handConroller.cell] == NO) {
            if ([self isLinearPathFreeBetweenStart:self.handConroller.cell end:moveToCell]) {
                
                // arm units
                [GridUtils performBlockBetweenFirstCell:self.handConroller.cell secondCell:moveToCell block:^(GridCoord cell, kDirection direction) {
                    
                    if ([GridUtils isCell:cell equalToCell:moveToCell] == NO) {
                        [self addArmNodeAtCell:cell movingDirection:direction];
                    }
                }];
                
                // hand sprite
                kDirection shouldFace = [GridUtils directionFromStart:self.handConroller.cell end:moveToCell];
                [self.handConroller setDirectionFacing:shouldFace];
                self.handConroller.position = [GridUtils absolutePositionForGridCoord:moveToCell unitSize:kSizeGridUnit origin:self.gridOrigin];
            }
        }
        return YES;
    }
    return NO;
}


#pragma mark - arm

- (void)addArmNodeAtCell:(GridCoord)cell movingDirection:(kDirection)direction
{  
    ArmNode *newArmNode;
    if ([self.armNodes count] > 0) {
        ArmNode *lastArmNode = [self.armNodes lastObject];
        kDirection firstExit = [GridUtils directionFromStart:cell end:[lastArmNode cell]];
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:firstExit secondExit:direction];
    }
    else {
        newArmNode = [[ArmNode alloc] initInCell:cell firstExit:self.handEntersFrom secondExit:direction];
    }
    
    [self addChild:newArmNode];
    [self.armNodes addObject:newArmNode];
    
    
    [self.cellObjectLibrary addObjectToLibrary:newArmNode cell:cell];
//    [self.cellsBlocked addObject:[self objectKeyForCell:cell]];

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
    NSMutableArray *objects = [self.cellObjectLibrary objectListForCell:cell];
    for (id obj in objects) {
        
        // add to this as we have more classes that block
        if ([obj isKindOfClass:[ArmNode class]]) {
            return YES;
        }
    }
    return NO;
}


@end
