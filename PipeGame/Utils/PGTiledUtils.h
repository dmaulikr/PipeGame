//
//  PGTiledUtils.h
//  PipeGame
//
//  Created by John Saba on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


// tiled object groups
FOUNDATION_EXPORT NSString *const kTLDGroupMeta;

// tiled objects
FOUNDATION_EXPORT NSString *const kTLDObjectEntry;
FOUNDATION_EXPORT NSString *const kTLDObjectConnection;

// tiled object properties
//FOUNDATION_EXPORT NSString *const kTLDPropertyDirection;

// tiled tile layers
FOUNDATION_EXPORT NSString *const kTLDLayerPipes1;
FOUNDATION_EXPORT NSString *const kTLDLayerPipes2;


@interface PGTiledUtils : NSObject

+ (ccColor3B)pipeColorAtLayer:(NSString *)layer;

// only works for 2 layers
+ (NSString *)oppositeLayer:(NSString *)layer;

@end
