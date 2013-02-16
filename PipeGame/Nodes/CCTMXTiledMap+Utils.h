//
//  CCTMXTiledMap+Utils.h
//  PipeGame
//
//  Created by John Saba on 2/16/13.
//
//

#import "CCTMXTiledMap.h"
#import "GridUtils.h"

@interface CCTMXTiledMap (Utils)

- (GridCoord)gridCoordForObjectNamed:(NSString *)objectName groupName:(NSString *)groupName;

@end
