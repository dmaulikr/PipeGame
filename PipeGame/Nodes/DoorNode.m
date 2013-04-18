//
//  DoorNode.m
//  PipeGame
//
//  Created by John Saba on 4/11/13.
//
//

#import "DoorNode.h"
#import "CoverPoint.h"
#import "PGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"

NSString *const kTLDObjectDoor = @"door";
NSString *const kTLDPropertyEdge = @"edge";


@implementation DoorNode

- (id)initWithDoor:(NSMutableDictionary *)door tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        self.colorGroup = [door valueForKey:kTLDPropertyColorGroup];
        self.edge = [PGTiledUtils directionNamed:[door valueForKey:kTLDPropertyEdge]];
        
        NSString *imageName = [self imageNameForColorGroup:_colorGroup open:NO];
        self.sprite = [SpriteUtils spriteWithTextureKey:imageName];
        [self rotateAndPosition:self.sprite edge:self.edge];
        [self addChild:self.sprite];
        
        self.layer = [[door valueForKey:kTLDPropertyLayer] intValue];
        
        self.cell = [tiledMap gridCoordForObject:door];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
        
        self.isOpen = NO;
        
        [self registerNotifications];        
    }
    return self;
}

- (void)rotateAndPosition:(CCSprite *)sprite edge:(kDirection)edge
{
    sprite.rotation = [SpriteUtils degreesForDirection:edge];
    
    switch (edge) {
        case kDirectionUp:
            sprite.position = ccp(self.contentSize.width/2, self.contentSize.height - sprite.boundingBox.size.height/2);
            break;
        case kDirectionRight:
            sprite.position = ccp(self.contentSize.width - sprite.boundingBox.size.width/2, self.contentSize.height/2);
            break;
        case kDirectionDown:
            sprite.position = ccp(self.contentSize.width/2, sprite.boundingBox.size.height/2);
            break;
        case kDirectionLeft:
            sprite.position = ccp(sprite.boundingBox.size.width/2, self.contentSize.height/2);
            break;
        default:
            NSLog(@"WARNING: edge '%i', not supported", edge);
            break;
    }
}

- (NSString *)imageNameForColorGroup:(NSString *)colorGroup open:(BOOL)open
{
    if ([colorGroup isEqualToString:kCoverPointColorGroupYellow]) {
        if (open) {
            return kImageNameDoorYellowOpen;
        }
        return kImageNameDoorYellow;
    }
    else if ([colorGroup isEqualToString:kCoverPointColorGroupRed]) {
        if (open) {
            return kImageNameDoorRedOpen;
        }
        return kImageNameDoorRed;
    }
    NSLog(@"WARNING: color group '%@' not supported", colorGroup);
    return nil;
}

- (void)open:(BOOL)open
{
    self.isOpen = open;
    NSString *imageName = [self imageNameForColorGroup:_colorGroup open:open];
    [SpriteUtils switchImageForSprite:self.sprite textureKey:imageName];
    [self rotateAndPosition:self.sprite edge:self.edge];
}

- (void)registerNotifications
{
    
}

@end
