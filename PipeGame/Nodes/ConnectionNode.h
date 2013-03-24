//
//  ConnectionNode.h
//  PipeGame
//
//  Created by John Saba on 2/26/13.
//
//

#import "CellNode.h"

@interface ConnectionNode : CellNode

@property (assign) int layerConnection;

- (id)initWithConnection:(NSMutableDictionary *)connection tiledMap:(CCTMXTiledMap *)tiledMap;

@end
