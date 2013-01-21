//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandController.h"

#import "SpriteUtils.h"

static NSString *const kImageNameHandSprite = @"handSprite.png";

@implementation HandController

- (id)initWithContentSize:(CGSize)size
{
    self = [super init];
    if (self) {
        
        self.contentSize = size;
        
        _handSprite = [CCSprite spriteWithFile:kImageNameHandSprite];
        _handSprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_handSprite];
        
        _facing = kDirectionNone;
    }
    return self;
}

-(void)setDirectionFacing:(kDirection)direction
{
    if (self.facing == kDirectionNone) {
        self.facing = kDirectionUp;
    }
    
//    NSLog(@"d: %g", [SpriteUtils degreesForDirection:direction startingAtDirection:self.facing]);
    NSLog(@"d: %g", [SpriteUtils degreesForDirection:direction]);

//    self.handSprite.rotation = [SpriteUtils degreesForDirection:direction startingAtDirection:self.facing];
    self.handSprite.rotation = [SpriteUtils degreesForDirection:direction];

    self.facing = direction;
}

@end
