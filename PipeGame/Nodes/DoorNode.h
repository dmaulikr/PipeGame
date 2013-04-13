//
//  DoorNode.h
//  PipeGame
//
//  Created by John Saba on 4/11/13.
//
//

#import "CellNode.h"

FOUNDATION_EXPORT NSString *const kTLDObjectDoor;
FOUNDATION_EXPORT NSString *const kTLDPropertyEdge;


@interface DoorNode : CellNode

@property (copy, nonatomic) NSString *colorGroup;
@property (assign) BOOL isOpen;
@property (assign) kDirection edge;

- (id)initWithDoor:(NSMutableDictionary *)door tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin;

@end
