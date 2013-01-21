//
//  HandController.m
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "HandController.h"

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
    }
    return self;
}



@end
