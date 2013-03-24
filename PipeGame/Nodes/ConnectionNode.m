//
//  ConnectionNode.m
//  PipeGame
//
//  Created by John Saba on 2/26/13.
//
//

#import "ConnectionNode.h"
#import "CCTMXTiledMap+Utils.h"
#import "PuzzleLayer.h"
#import "PGTiledUtils.h"

NSString *const kTLDPropertyConnectionA = @"a";
NSString *const kTLDPropertyConnectionB = @"b";


@implementation ConnectionNode

- (id)initWithConnection:(NSMutableDictionary *)connection tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        // position
        GridCoord gridCoord = [tiledMap gridCoordForObject:connection];
        self.position = [GridUtils absolutePositionForGridCoord:gridCoord unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
        
        // doesn't belong to a specific layer
        self.layer = kPipeLayerAny;
    }
    return self;
}

@end
