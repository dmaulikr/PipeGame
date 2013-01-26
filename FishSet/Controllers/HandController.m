//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandController.h"
#import "SpriteUtils.h"

static NSString *const kImageNameHandSprite = @"handSprite.png";
static int const kSpeedCellsPerSecond = 10;

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
    }
    return self;
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

- (BOOL)didHandChangeCells
{
    
}

@end
