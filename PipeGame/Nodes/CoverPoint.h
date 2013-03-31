//
//  CoverPoint.h
//  PipeGame
//
//  Created by John Saba on 3/23/13.
//
//

#import "CellNode.h"

FOUNDATION_EXPORT NSString *const kTLDObjectCoverPoint;

@interface CoverPoint : CellNode

@property (strong, nonatomic) CCSprite *sprite;
@property (assign) BOOL isCovered;

-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin;

@end
