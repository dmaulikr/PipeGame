//
//  PuzzleMenuLayer.h
//  PipeGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "cocos2d.h"

@interface PuzzleMenuLayer : CCLayerColor

+ (CCScene *)scene;

@property (strong, nonatomic) NSMutableArray *maps;

@end
