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
#import "HandController.h"

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
        
        // hand
        _handConroller = [[HandController alloc] initWithContentSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit)];
        _handEntryCoord = [DataUtils puzzleEntryCoord:puzzle];
        _handConroller.position = [GridUtils absolutePositionForGridCoord:_handEntryCoord unitSize:kSizeGridUnit origin:_gridOrigin];
        [self addChild:_handConroller];
        
        [_handConroller setDirectionFacing:[DataUtils puzzleEntryDireciton:puzzle]];
        
        // arm
        _armController = [[ArmController alloc] init];
        [self addChild:_armController];
        
        
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
    
    if ([self isPathFreeBetweenStart:self.handConroller.moveFromCell end:self.handConroller.moveToCell]) {
        
        kDirection shouldFace = [GridUtils directionFromStart:self.handConroller.cell end:self.handConroller.moveToCell];
        if (shouldFace != self.handConroller.facing) {
            CCCallFunc *completion = [CCCallFunc actionWithTarget:self.handConroller selector:@selector(movePath)];
            [self.handConroller rotateToFacing:shouldFace withCompletion:completion];
        }
        else {
            [self.handConroller movePath];
        }
    }
    
    return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}


#pragma mark - helpers

- (BOOL)isPathFreeBetweenStart:(GridCoord)start end:(GridCoord)end
{
    // movement along y 
    if (start.x == end.x) {
        // needs implementation
        return YES;
    }
    // movement along x 
    else if (start.y == end.y) {
        // needs implementation
        return YES;
    }
    // non-linear movement not allowed.
    else {
        return NO;
    }
}






// dropped in from arm controller

- (NSInteger)keyForCell:(GridCoord)cell
{
    return [[NSString stringWithFormat:@"1%i%i", cell.x, cell.y] intValue];
}

- (void)addCell:(GridCoord)cell
{
    CCSprite *cellSprite = [CCSprite spriteWithFile:kImageArmUnit];
    cellSprite.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    [self addChild:cellSprite z:0 tag:[self keyForCell:cell]];
}

- (void)removeCell:(GridCoord)cell
{
    CCSprite *cellSprite = (CCSprite *)[self getChildByTag:[self keyForCell:cell]];
    if (cellSprite != nil) {
        [cellSprite removeFromParentAndCleanup:YES];
    }
}


@end
