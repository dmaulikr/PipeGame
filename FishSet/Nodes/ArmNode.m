//
//  ArmNode.m
//  FishSet
//
//  Created by John Saba on 2/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ArmNode.h"
#import "TextureUtils.h"
#import "GameConstants.h"
#import "SpriteUtils.h"
#import "PuzzleLayer.h"

@implementation ArmNode

- (id)initWithTextureKey:(NSString *)key cell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
         
        _sprite = [SpriteUtils spriteWithTextureKey:key];
        _sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_sprite];

        self.position = [GridUtils absolutePositionForGridCoord:cell unitSize:kSizeGridUnit origin:[PuzzleLayer sharedGridOrigin]];
    }
    return self;
}


@end
