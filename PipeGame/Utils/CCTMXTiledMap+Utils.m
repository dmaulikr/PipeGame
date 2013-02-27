//
//  CCTMXTiledMap+Utils.m
//  PipeGame
//
//  Created by John Saba on 2/16/13.
//
//



#import "CCTMXTiledMap+Utils.h"

// tiled object groups
NSString *const kTLDGroupMeta = @"meta";

// tiled objects
NSString *const kTLDObjectEntry = @"entry";
NSString *const kTLDObjectConnection = @"connection";

// tiled object properties
NSString *const kTLDPropertyDirection = @"direction";


@implementation CCTMXTiledMap (Utils)

- (NSMutableDictionary *)objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName
{
    CCTMXObjectGroup *objectGroup = [self objectGroupNamed:groupName];
    if (objectGroup != nil) {
        NSMutableDictionary *object = [objectGroup objectNamed:objectName];
        if (object != nil) {
            return object;
        }
        else {
            NSLog(@"warning: object named %@ does not exist in group %@", objectName, groupName);
        }
    }
    else {
        NSLog(@"warning: object group %@ does not exist", groupName);
    }
    return nil;
}

- (NSMutableArray *)objectsWithName:(NSString *)objectName groupName:(NSString *)groupName
{
    NSMutableArray *result = [NSMutableArray array];
    CCTMXObjectGroup *objectGroup = [self objectGroupNamed:groupName];
    if (objectGroup != nil) {
        for (NSMutableDictionary *object in objectGroup.objects) {
            if( [[object valueForKey:@"name"] isEqualToString:objectName] ) {
                [result addObject:object];
            }
        }
    }
    return result;
}

- (GridCoord)gridCoordForObjectNamed:(NSString *)objectName groupNamed:(NSString *)groupName
{
    NSMutableDictionary *object = [self objectNamed:objectName groupNamed:groupName];
    return [self gridCoordForObject:object groupName:groupName];
}

- (GridCoord)gridCoordForObject:(NSMutableDictionary *)object groupName:(NSString *)groupName
{
    if (object != nil) {
        NSNumber *x = [object objectForKey:@"x"];
        NSNumber *y = [object objectForKey:@"y"];
        return [self gridCoordForCocos2dPosition:ccp([x floatValue], [y floatValue])];
    }
    NSLog(@"warning: invalid object, returning coord -1, -1");
    return GridCoordMake(-1, -1);
}

- (id)objectPropertyNamed:(NSString *)propertyName objectNamed:(NSString *)objectName groupNamed:(NSString *)groupName
{
    NSMutableDictionary *object = [self objectNamed:objectName groupNamed:groupName];
    if (object != nil) {
        id property = [object objectForKey:propertyName];
        if (property != nil) {
            return property;
        }
        else {
            NSLog(@"warning: property named %@ does not exist", propertyName);
        }
    }
    return nil;
}

- (GridCoord)gridCoordForCocos2dPosition:(CGPoint)position
{
    return [GridUtils gridCoordForAbsolutePosition:position unitSize:self.tileSize.width origin:ccp(0, 0)];
} 

+ (void)performBlockForTilesInLayer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile))perform;
{
    for( int x = 0; x < layer.layerSize.width; x++) {
        for( int y = 0; y < layer.layerSize.height; y++ ) {
            CCSprite *tile = [layer tileAt:ccp(x, y)];
            perform(tile);
        }
    }
}

- (void)performBlockForAllTiles:(void (^)(CCTMXLayer *layer, CCSprite *tile))perform;
{
    for (CCTMXLayer *layer in self.children) {
        [CCTMXTiledMap performBlockForTilesInLayer:layer perform:^(CCSprite *tile) {
            perform(layer, tile);
        }];
    }
}

// cell is standard game GridCoord
- (void)performBlockForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer perform:(void (^)(CCSprite *tile, NSDictionary *tileProperties))perform;
{
    GridCoord tileCoord = [GridUtils tiledGridCoordForGameGridCoord:cell tileMapHeight:self.mapSize.height];
    int tileGid = [layer tileGIDAt:CGPointMake(tileCoord.x, tileCoord.y)];
    if (tileGid) {
        CCSprite *tile = [layer tileAt:CGPointMake(tileCoord.x, tileCoord.y)];
        NSDictionary *properties = [self propertiesForGID:tileGid];
        perform(tile, properties);
    }
    else {
        NSLog(@"warning: tile does not exist");
    }
}

// cell is standard game GridCoord
- (BOOL)testConditionForTileAtCell:(GridCoord)cell layer:(CCTMXLayer *)layer condition:(BOOL (^)(CCSprite *tile, NSDictionary *tileProperties))condition
{
    GridCoord tileCoord = [GridUtils tiledGridCoordForGameGridCoord:cell tileMapHeight:self.mapSize.height];
    int tileGid = [layer tileGIDAt:CGPointMake(tileCoord.x, tileCoord.y)];
    if (tileGid) {
        CCSprite *tile = [layer tileAt:CGPointMake(tileCoord.x, tileCoord.y)];
        NSDictionary *properties = [self propertiesForGID:tileGid];
        return condition(tile, properties);
    }
    NSLog(@"warning: tile does not exist, returning NO");
    return NO;
}




@end
