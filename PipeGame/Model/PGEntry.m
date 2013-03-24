//
//  PGEntry.m
//  PipeGame
//
//  Created by John Saba on 2/27/13.
//
//

#import "PGEntry.h"
#import "CCTMXTiledMap+Utils.h"
#import "PGTiledUtils.h"

static NSString *const kEntryFacing = @"facing";
static NSString *const kEntryLayer = @"layer";

@implementation PGEntry

- (id)initWithEntry:(NSMutableDictionary *)entry tileMap:(CCTMXTiledMap *)tileMap
{
    self = [super initWithTiledObject:entry tileMap:tileMap];
    if (self) {
        NSString *direction = [CCTMXTiledMap objectPropertyNamed:kEntryFacing object:entry];
        _direction = [PGTiledUtils directionNamed:direction];
        _layer = [[CCTMXTiledMap objectPropertyNamed:kEntryLayer object:entry] intValue];
    }
    return self;
}


@end
