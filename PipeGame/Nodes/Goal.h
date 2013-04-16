//
//  Goal.h
//  PipeGame
//
//  Created by John Saba on 4/14/13.
//
//

#import "CellNode.h"

@interface Goal : CellNode

- (id)initWithGoal:(NSMutableDictionary *)goal tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin;

@end

