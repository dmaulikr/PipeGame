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

@implementation CoverPoint

// TODO: does this need tiled map?
-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        // add sprites
        self.sprite = [self createAndCenterSpriteNamed:kImageNameRat];
        [self addChild:self.sprite];
        
        // layer
        self.layer = [[coverPoint valueForKey:kTLDPropertyLayer] intValue];
        
        // position
        self.cell = [tiledMap gridCoordForObject:coverPoint];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
        
        _isCovered = NO;
        
        [self registerNotifications];
    }
    return self;

}

-(void) registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCellNodeLibraryChangedContents:) name:kPGNotificationCellNodeLibraryChangedContents object:nil];
}

-(void) handleCellNodeLibraryChangedContents:(NSNotification *)notification
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

-(void) cover
{
    self.sprite.rotation = 180;
    self.isCovered = YES;
}

-(void) uncover
{
    self.sprite.rotation = 0;
    self.isCovered = NO;
}

@end
