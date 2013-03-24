//
//  PGTiledUtils.h
//  PipeGame
//
//  Created by John Saba on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConstants.h"

typedef enum
{
    kPipeLayerAny = 0,
    kPipeLayer1,
    kPipeLayer2,
} kPipeLayer;

// tiled object groups
FOUNDATION_EXPORT NSString *const kTLDGroupMeta;

// tiled objects
FOUNDATION_EXPORT NSString *const kTLDObjectEntry;
FOUNDATION_EXPORT NSString *const kTLDObjectConnection;

// tiled object properties
FOUNDATION_EXPORT NSString *const kTLDPropertyLayer;

// tiled tile layers
FOUNDATION_EXPORT NSString *const kTLDLayerPipes1;
FOUNDATION_EXPORT NSString *const kTLDLayerPipes2;


@interface PGTiledUtils : NSObject

+ (ccColor3B)pipeColorAtLayer:(int)layer;

// only works for 2 layers
+ (int)oppositeLayer:(int)layer;

+(NSString *) layerName:(int)layer;

+(kDirection) directionNamed:(NSString *)direction;

@end
