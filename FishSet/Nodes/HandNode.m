//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandNode.h"

#import "SpriteUtils.h"
#import "GridUtils.h"
#import "GameConstants.h"
#import "PuzzleLayer.h"
#import "TextureUtils.h"

@implementation HandNode

- (id)initWithContentSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.contentSize = size;
        
        _handSprite = [SpriteUtils spriteWithTextureKey:kImageNameHand];
        _handSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_handSprite];
        
        _facing = kDirectionNone;
    }
    return self;
}

- (void)setDirectionFacing:(kDirection)direction
{
    self.handSprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.facing = direction;
}

@end
