//
//  BackgroundLayer.m
//  PipeGame
//
//  Created by John Saba on 3/18/13.
//
//

#import "BackgroundLayer.h"
#import "CCActionInterval.h"

@implementation BackgroundLayer

-(void) tintToColor:(ccColor3B)color duration:(ccTime)d
{
    CCTintTo *tint = [CCTintTo actionWithDuration:d red:color.r green:color.g blue:color.b];
    [self runAction:tint];
}

@end
