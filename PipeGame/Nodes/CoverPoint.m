//
//  CoverPoint.m
//  PipeGame
//
//  Created by John Saba on 3/23/13.
//

#import "CoverPoint.h"
#import "SpriteUtils.h"
#import "TextureUtils.h"
#import "PGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "PuzzleLayer.h"
#import "GridUtils.h"
#import "CellObjectLibrary.h"
#import "HandNode.h"
#import "ArmNode.h"

NSString *const kTLDObjectCoverPoint = @"rat";

NSString *const kTLDPropertyColorGroup = @"color";

NSString *const kCoverPointColorGroupPurple = @"purple";
NSString *const kCoverPointColorGroupRed = @"red";

@implementation CoverPoint

// TODO: does this need tiled map?
- (id)initWithCoverPoint:(NSMutableDictionary *)coverPoint tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        self.colorGroup = [coverPoint valueForKey:kTLDPropertyColorGroup];
        
        NSString *imageName = [self imageNameForColorGroup:_colorGroup];
        self.sprite = [self createAndCenterSpriteNamed:imageName];
        [self addChild:self.sprite];
        
        self.layer = [[coverPoint valueForKey:kTLDPropertyLayer] intValue];
        
        self.cell = [tiledMap gridCoordForObject:coverPoint];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
        
        self.isCovered = NO;
        
        [self registerNotifications];
    }
    return self;

}

- (NSString *)imageNameForColorGroup:(NSString *)colorGroup
{
    if ([colorGroup isEqualToString:kCoverPointColorGroupPurple]) {
        return kImageNameRatPurple;
    }
    else if ([colorGroup isEqualToString:kCoverPointColorGroupRed]) {
        return kImageNameRatRed;
    }
    NSLog(@"WARNING: color group '%@' not supported", colorGroup);
    return nil;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellNodeLibraryChangedContents:) name:kPGNotificationCellNodeLibraryChangedContents object:nil];
}

- (void)handleCellNodeLibraryChangedContents:(NSNotification *)notification
{
    CellObjectLibrary *library = notification.object;
    BOOL collision = [library containsAnyNodeOfKinds:@[[HandNode class], [ArmNode class]] layer:self.layer cell:self.cell];
    if (collision && !self.isCovered) {
        [self cover];
    }
    else if (!collision && self.isCovered) {
        [self uncover];
    }
}

- (void)cover
{
    self.sprite.rotation = 180;
    self.isCovered = YES;
    
    [self.delegate coverPointTouched:self];
}

- (void)uncover
{
    self.sprite.rotation = 0;
    self.isCovered = NO;
    
    [self.delegate coverPointTouched:self];
}

@end
