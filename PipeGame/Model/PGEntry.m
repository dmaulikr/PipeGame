//
//  PGEntry.m
//  PipeGame
//
//  Created by John Saba on 2/27/13.
//
//

#import "PGEntry.h"
#import "CCTMXTiledMap+Utils.h"

static NSString *const kEntryDirection = @"direction";
static NSString *const kEntryLayer = @"layer";

@implementation PGEntry

- (id)initWithEntry:(NSMutableDictionary *)entry tileMap:(CCTMXTiledMap *)tileMap
{
    self = [super initWithTiledObject:entry tileMap:tileMap];
    if (self) {
        _direction = [CCTMXTiledMap objectPropertyNamed:kEntryDirection object:entry];
        _pipeLayer = [CCTMXTiledMap objectPropertyNamed:kEntryLayer object:entry];
    }
    return self;
}


@end
