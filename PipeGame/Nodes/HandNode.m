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
#import "ArmNode.h"

NSString *const kPGNotificationHandNodeTouched = @"HandNodeTouched";


@implementation HandNode

- (id)initWithContentSize:(CGSize)size
{
    self = [super init];
    if (self) {
        
        self.contentSize = size;
        
        _sprite = [SpriteUtils spriteWithTextureKey:kImageNameHand];
        _sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_sprite];
        
        _connectionSprite = [SpriteUtils spriteWithTextureKey:kImageNameHandThrough];
        _connectionSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        _connectionSprite.visible = NO;
        [self addChild:_connectionSprite];
        
        // setup for sending notifications
        self.shouldSendPGTouchNotifications = YES;
        self.pgTouchNotification = kPGNotificationHandNodeTouched;
        
        _facing = kDirectionNone;
        
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleArmStackChanged:) name:kPGNotificationArmStackChanged object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDirectionFacing:(kDirection)direction
{
    self.sprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.connectionSprite.rotation = [SpriteUtils degreesForDirection:direction];
    self.facing = direction;
}

- (void)setAtConnection:(BOOL)atConnection
{
    self.sprite.visible = !atConnection;
    self.connectionSprite.visible = atConnection;
}

- (void)handleArmStackChanged:(NSNotification *)notification
{
    NSMutableArray *armStack = (NSMutableArray *)notification.object;
    
    if (armStack.count > 0) {
        ArmNode *lastArmNode = [armStack lastObject];
        BOOL isEmerging = (![lastArmNode.firstPipeLayer isEqualToString:self.firstPipeLayer]);
        [self setAtConnection:isEmerging];
    }
}

@end
