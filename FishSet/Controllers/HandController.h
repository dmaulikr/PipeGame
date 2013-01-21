//
//  HandController.h
//  FishSet
//
//  Created by John Saba on 1/20/13.
//
//

#import "cocos2d.h"
#import "GameTypes.h"

@interface HandController : CCNode

@property (nonatomic, strong) CCSprite *handSprite;
@property (assign) kDirection facing;

- (id)initWithContentSize:(CGSize)size;

@end
