//
//  Goal.m
//  PipeGame
//
//  Created by John Saba on 4/14/13.
//
//

#import "Goal.h"
#import "TextureUtils.h"
#import "PGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"

@implementation Goal

- (id)initWithGoal:(NSMutableDictionary *)goal tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        
        self.sprite = [self createAndCenterSpriteNamed:kImageNameGoal];
        [self addChild:self.sprite];
        
        self.layer = [[goal valueForKey:kTLDPropertyLayer] intValue];
    }
    return self;
}

@end
