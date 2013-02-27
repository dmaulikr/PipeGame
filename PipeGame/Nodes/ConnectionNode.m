//
//  ConnectionNode.m
//  PipeGame
//
//  Created by John Saba on 2/26/13.
//
//

#import "ConnectionNode.h"

@implementation ConnectionNode

+ (id)nodeWithConnectionToLayerA:(int)layerA layerB:(int)layerB gridCoord:(GridCoord)gridCoord
{
    return [[ConnectionNode alloc] initWithConnectionToLayerA:layerA layerB:layerB gridCoord:gridCoord];
}

- (id)initWithConnectionToLayerA:(int)layerA layerB:(int)layerB gridCoord:(GridCoord)gridCoord
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
