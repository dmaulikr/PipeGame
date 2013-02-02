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
#import "HandNode.h"
#import "GridUtils.h"

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
        
        // hand
        _handConroller = [[HandNode alloc] initWithContentSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit)];
        _handEntryCoord = [DataUtils puzzleEntryCoord:puzzle];
        _handConroller.position = [GridUtils absolutePositionForGridCoord:_handEntryCoord unitSize:kSizeGridUnit origin:_gridOrigin];
        [self addChild:_handConroller];
        
        [_handConroller setDirectionFacing:[DataUtils puzzleEntryDireciton:puzzle]];
        _lastHandCell = _handEntryCoord;
        
        // arm
        _armUnits = [NSMutableDictionary dictionary];
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
    
    // touch a cell to move to it's position if path is free and in a line
    self.handConroller.moveToCell = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    self.handConroller.moveFromCell = self.handConroller.cell;
    
    if ([GridUtils isCell:self.handConroller.moveToCell equalToCell:self.handConroller.moveFromCell] == NO) {
        if ([self isLinearPathFreeBetweenStart:self.handConroller.moveFromCell end:self.handConroller.moveToCell]) {
            
            // arm units
            [GridUtils performBlockBetweenFirstCell:self.handConroller.moveFromCell secondCell:self.handConroller.moveToCell block:^(GridCoord cell) {
                if ([GridUtils isCell:cell equalToCell:self.handConroller.moveToCell] == NO) {
                    [self addArmUnitAtCell:cell];
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

- (void)addArmUnitAtCell:(GridCoord)cell
{
    CCSprite *cellSprite = [CCSprite spriteWithFile:kImageArmUnit];
    cellSprite.position = [GridUtils absoluteSpritePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    [self addChild:cellSprite z:0];
    
    [self.armUnits setObject:cellSprite forKey:[self objectKeyForCell:cell]];
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
