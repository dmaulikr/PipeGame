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

NSString *const kTLDPropertyConnectionA = @"a";
NSString *const kTLDPropertyConnectionB = @"b";


@implementation ConnectionNode

+ (id)nodeWithConnection:(NSMutableDictionary *)connection tileMap:(CCTMXTiledMap *)tileMap
{
    NSString *layerA= [connection objectForKey:kTLDPropertyConnectionA];
    NSString *layerB = [connection objectForKey:kTLDPropertyConnectionB];
    GridCoord gridCoord = [tileMap gridCoordForObject:connection];
        
    return [[ConnectionNode alloc] initWithConnectionToLayerA:layerA layerB:layerB gridCoord:gridCoord];
}

- (id)initWithConnectionToLayerA:(NSString *)layerA layerB:(NSString *)layerB gridCoord:(GridCoord)gridCoord
{
    self = [super init];
    if (self) {
        self.position = [GridUtils absolutePositionForGridCoord:gridCoord unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
        self.pipeLayers = @[layerA, layerB];
    }
    return self;
}

@end
