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
#import "ArmController.h"

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
    self.moveTo = [GridUtils gridCoordForAbsolutePosition:touchPosition unitSize:kSizeGridUnit origin:self.gridOrigin];
    
    if ([self isPathFreeBetweenStart:[self handCoord] end:self.moveTo]) {
        
        CCCallFunc *completion = [CCCallFunc actionWithTarget:self selector:@selector(move)];
        
        kDirection shouldFace = [GridUtils directionFromStart:[self handCoord] end:self.moveTo];
        
        if (shouldFace != self.handConroller.facing) {
            [self.handConroller rotateToFacing:shouldFace withCompletion:completion];
        }
        else {
            [self move];
        }
    }
    
    return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}

#pragma mark - moving 

- (void)move
{
    CGPoint destination = [GridUtils absolutePositionForGridCoord:self.moveTo unitSize:kSizeGridUnit origin:self.gridOrigin];
    
    int steps = [GridUtils numberOfStepsBetweenStart:[self handCoord] end:self.moveTo];
    NSLog(@"steps: %i", steps);
    
    id actionMove = [CCMoveTo actionWithDuration:((float)steps / (float)self.handConroller.cellsPerSecond) position:destination];
    [self.handConroller runAction:actionMove];
}


#pragma mark - helpers

- (GridCoord)handCoord
{
    return [GridUtils gridCoordForAbsolutePosition:self.handConroller.position unitSize:kSizeGridUnit origin:self.gridOrigin];
}

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

@end
