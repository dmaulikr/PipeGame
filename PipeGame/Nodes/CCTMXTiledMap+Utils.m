//
//  CCTMXTiledMap+Utils.m
//  PipeGame
//
//  Created by John Saba on 2/16/13.
//
//

#import "CCTMXTiledMap+Utils.h"

@implementation CCTMXTiledMap (Utils)

- (GridCoord)gridCoordForObjectNamed:(NSString *)objectName groupName:(NSString *)groupName
{
    CCTMXObjectGroup *objectGroup = [self objectGroupNamed:groupName];
    if (objectGroup != nil) {
        NSMutableDictionary *object = [objectGroup objectNamed:objectName];
        if (object != nil) {
            NSNumber *x = [object objectForKey:@"x"];
            NSNumber *y = [object objectForKey:@"y"];
            return [self gridCoordForCocos2dPosition:ccp([x floatValue], [y floatValue])];
        }
        else {
            NSLog(@"warning: object named %@ does not exist in group %@", objectName, groupName);
        }
    }
    else {
        NSLog(@"warning: object group %@ does not exist", groupName);
    }
    return GridCoordMake(-1, -1);
}
     
- (GridCoord)gridCoordForCocos2dPosition:(CGPoint)position
{
    return [GridUtils gridCoordForAbsolutePosition:position unitSize:self.tileSize.width origin:ccp(0, 0)];
}

@end
