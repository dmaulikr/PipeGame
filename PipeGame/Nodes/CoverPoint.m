//
//  CoverPoint.m
//  PipeGame
//
//  Created by John Saba on 3/23/13.
//
//

#import "CoverPoint.h"
#import "SpriteUtils.h"
#import "TextureUtils.h"

@implementation CoverPoint

-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tileMap:(CCTMXTiledMap *)tileMap
{
    self = [super init];
    if (self) {
        // add sprites
        self.sprite = [self createAndCenterSpriteNamed:kImageNameRat];
        [self addChild:self.sprite];
    }
    return self;

}

@end
