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

NSString *const kPGNotificationHandNodeTouched = @"HandNodeTouched";


@implementation HandNode

- (id)initWithContentSize:(CGSize)size
{
    self = [super init];
    if (self) {
        
        // test vertex
        self.sprite.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColorAlphaTest];
        
        self.contentSize = size;
        
        _sprite = [SpriteUtils spriteWithTextureKey:kImageNameHand];
        _sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_sprite];
        
        // setup for sending notifications
        self.shouldSendPGTouchNotifications = YES;
        self.pgTouchNotification = kPGNotificationHandNodeTouched;
        
        _facing = kDirectionNone;
    }
    return self;
}

- (void)setDirectionFacing:(kDirection)direction
{
    self.sprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.facing = direction;
}

@end
