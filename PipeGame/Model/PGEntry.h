//
//  PGEntry.h
//  PipeGame
//
//  Created by John Saba on 2/27/13.
//
//

#import "PGTiledObject.h"


@interface PGEntry : PGTiledObject

@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *pipeLayer;

- (id)initWithEntry:(NSMutableDictionary *)entry tileMap:(CCTMXTiledMap *)tileMap;

@end
