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

- (id)initWithConnection:(NSMutableDictionary *)connection tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        // position
        self.cell = [tiledMap gridCoordForObject:connection];
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
        
        // doesn't belong to a specific layer
        self.layer = kPipeLayerAny;
    }
    return self;
}

@end
