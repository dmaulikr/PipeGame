//
//  PGTiledObject.m
//  PipeGame
//
//  Created by John Saba on 2/27/13.
//
//

#import "PGTiledObject.h"
#import "CCTMXTiledMap+Utils.h"

@implementation PGTiledObject

- (id)initWithTiledObject:(NSMutableDictionary *)object tileMap:(CCTMXTiledMap *)tileMap
{
    self = [super init];
    if (self) {
        _cell = [tileMap gridCoordForObject:object];
    }
    return self;
}

@end
