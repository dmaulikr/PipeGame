//
//  CCTMXTiledMap+Utils.h
//  PipeGame
//
//  Created by John Saba on 2/16/13.
//
//

#import "CCTMXTiledMap.h"
#import "GridUtils.h"

// tiled object groups
FOUNDATION_EXPORT NSString *const kTLDGroupMeta;

// tiled objects
FOUNDATION_EXPORT NSString *const kTLDObjectEntry;

// tiled object properties
FOUNDATION_EXPORT NSString *const kTLDPropertyDirection;


@interface CCTMXTiledMap (Utils)

- (NSMutableDictionary *)objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;
- (GridCoord)gridCoordForObjectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;
- (id)objectPropertyNamed:(NSString *)propertyName objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;

+ (void)performBlockForTilesInLayer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile))perform;
- (void)performBlockForAllTiles:(void (^)(CCTMXLayer *layer, CCSprite *tile))perform;
- (void)performBlockForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile, NSDictionary *tileProperties))perform;
- (BOOL)testConditionForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer condition:(BOOL (^)(CCSprite *tile, NSDictionary *tileProperties))condition;

@end
