//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandController.h"

#import "SpriteUtils.h"
#import "GridUtils.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"

static NSString *const kImageNameHandSprite = @"handSprite.png";
static float const kSpeedCellsPerSecond = 10.0;

@implementation HandController

- (id)initWithContentSize:(CGSize)size
{
    self = [super init];
    if (self) {
        
        self.contentSize = size;
        
        _handSprite = [CCSprite spriteWithFile:kImageNameHandSprite];
        _handSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_handSprite];
        
        _facing = kDirectionNone;
        _cellsPerSecond = kSpeedCellsPerSecond;
        _isMoving = NO;
    }
    return self;
}

- (GridCoord)cell
{
    return [GridUtils gridCoordForAbsolutePosition:self.position unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
}

- (void)setDirectionFacing:(kDirection)direction
{
    self.handSprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.facing = direction;
}

- (void)rotateToFacing:(kDirection)direction withCompletion:(CCCallFunc *)completion
{
    self.facing = direction;

    float angleDegrees = fabs([SpriteUtils degreesForDirection:direction]);
    float rotateDuration = .1;
    
    [self.handSprite runAction:
     [CCSequence actions:
      [CCRotateTo actionWithDuration:rotateDuration angle:angleDegrees],
      completion,
      nil]
     ];
}

- (void)movePath
{
    [self moveFromStart:self.moveFromCell toEnd:self.moveToCell];
}

- (void)moveFromStart:(GridCoord)start toEnd:(GridCoord)end
{    
    self.isMoving = YES;
    CGPoint destination = [GridUtils absolutePositionForGridCoord:end unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    int steps = [GridUtils numberOfStepsBetweenStart:start end:end];
    id actionMove = [CCMoveTo actionWithDuration:((float)steps / self.cellsPerSecond) position:destination];
    id actionMoveFinished = [CCCallFunc actionWithTarget:self selector:@selector(moveFinished)];
    
    [self runAction:[CCSequence actions:actionMove, actionMoveFinished, nil]];
}

- (void)moveFinished
{
    self.isMoving = NO;
}






@end
