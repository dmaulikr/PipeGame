//
//  PGTiledUtiles.m
//  PipeGame
//
//  Created by John Saba on 3/2/13.
//
//

#import "PGTiledUtils.h"
#import "ColorUtils.h"

// tiled object groups
NSString *const kTLDGroupMeta = @"meta";

// tiled objects
NSString *const kTLDObjectEntry = @"entry";
NSString *const kTLDObjectConnection = @"connection";

// tiled object properties
//NSString *const kTLDPropertyDirection = @"direction";

// tiled tile layers
NSString *const kTLDLayerPipes1 = @"pipes1";
NSString *const kTLDLayerPipes2 = @"pipes2";


@implementation PGTiledUtils

+ (ccColor3B)pipeColorAtLayer:(NSString *)layer
{
    if ([layer isEqualToString:kTLDLayerPipes1]) {
        return [ColorUtils pipeLayer1Color];
    }
    else if ([layer isEqualToString:kTLDLayerPipes2]) {
        return [ColorUtils pipeLayer2Color];
    }
    NSLog(@"layer: %@ is not supported with a color, returning white", layer);
    return ccWHITE;
}

// only works for 2 layers
+ (NSString *)oppositeLayer:(NSString *)layer
{
    if ([layer isEqualToString:kTLDLayerPipes1]) {
        return kTLDLayerPipes2;
    }
    return kTLDLayerPipes1;
}

@end
