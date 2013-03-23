//
//  CoverPoint.h
//  PipeGame
//
//  Created by John Saba on 3/23/13.
//
//

#import "CellNode.h"

@interface CoverPoint : CellNode

@property (strong, nonatomic) CCSprite *sprite;

-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tileMap:(CCTMXTiledMap *)tileMap;

@end
