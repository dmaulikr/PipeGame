//
//  ConnectionNode.h
//  PipeGame
//
//  Created by John Saba on 2/26/13.
//
//

#import "CellNode.h"

@interface ConnectionNode : CellNode

+ (id)nodeWithConnection:(NSMutableDictionary *)connection tileMap:(CCTMXTiledMap *)tileMap;

@end
