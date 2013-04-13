//
//  CCTMXTiledMap+Utils.h
//  PipeGame
//
//  Created by John Saba on 2/16/13.
//
//

#import "CCTMXTiledMap.h"
#import "GridUtils.h"


@interface CCTMXTiledMap (Utils)

+ (id)objectPropertyNamed:(NSString *)propertyName object:(NSMutableDictionary *)object;
+ (void)performBlockForTilesInLayer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile))perform;
- (NSMutableDictionary *)objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;
- (NSMutableArray *)objectsWithName:(NSString *)objectName groupName:(NSString *)groupName;
- (GridCoord)gridCoordForObjectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;
- (GridCoord)gridCoordForObject:(NSMutableDictionary *)object;
- (id)objectPropertyNamed:(NSString *)propertyName objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName;
- (void)performBlockForAllTiles:(void (^)(CCTMXLayer *layer, CCSprite *tile))perform;
- (void)performBlockForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile, NSDictionary *tileProperties))perform;
- (BOOL)testConditionForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer condition:(BOOL (^)(CCSprite *tile, NSDictionary *tileProperties))condition;
- (NSDictionary *)propertiesForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer;

@end
