//
//  PGTiledObject.h
//  PipeGame
//
//  Created by John Saba on 2/27/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@interface PGTiledObject : NSObject

@property (assign) GridCoord cell;

- (id)initWithTiledObject:(NSMutableDictionary *)object tileMap:(CCTMXTiledMap *)tileMap;

@end
