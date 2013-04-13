//
//  CoverPoint.h
//  PipeGame
//
//  Created by John Saba on 3/23/13.
//
//

#import "CellNode.h"

@class CoverPoint;

FOUNDATION_EXPORT NSString *const kTLDObjectCoverPoint;

FOUNDATION_EXPORT NSString *const kTLDPropertyColorGroup;

FOUNDATION_EXPORT NSString *const kCoverPointColorGroupPurple;
FOUNDATION_EXPORT NSString *const kCoverPointColorGroupRed;

@protocol CoverPointDelegate <NSObject>

- (void)coverPointTouched:(CoverPoint *)coverPoint;

@end


@interface CoverPoint : CellNode

@property (strong, nonatomic) CCSprite *sprite;
@property (assign) BOOL isCovered;
@property (copy, nonatomic) NSString *colorGroup;

@property (weak, nonatomic) id<CoverPointDelegate> delegate;

-(id) initWithCoverPoint:(NSMutableDictionary *)coverPoint tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin;

@end
