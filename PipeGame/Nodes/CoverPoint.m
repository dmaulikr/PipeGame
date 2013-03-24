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

NSString *const kTLDObjectCoverPoint = @"rat";

@implementation CoverPoint

// TODO: does this need tiled map?
-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        // add sprites
        self.sprite = [self createAndCenterSpriteNamed:kImageNameRat];
        [self addChild:self.sprite];
        
        // layer
        self.layer = [[coverPoint valueForKey:kTLDPropertyLayer] intValue];
        
        // position
        // TODO: same code as in connection node
        GridCoord gridCoord = [tiledMap gridCoordForObject:coverPoint];
        self.position = [GridUtils absolutePositionForGridCoord:gridCoord unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    }
    return self;

}

@end
