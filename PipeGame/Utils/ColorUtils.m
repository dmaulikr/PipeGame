//
//  ColorUtils.m
//  FishSet
//
//  Created by John Saba on 2/4/13.
//
//

#import "ColorUtils.h"

@implementation ColorUtils

#pragma mark - color 

+ (ccColor3B)darkBlue
{
    return ccc3(20, 50, 60);
}

+ (ccColor3B)darkRed
{
    return ccc3(45, 15, 20);
}

+ (ccColor3B)brightGreen;
{
    return ccc3(175, 255, 175);
}

#pragma mark - context

+ (ccColor3B)tintArmSelected
{
    return [self brightGreen];
}

+ (ccColor3B)pipeLayer1Color
{
    return [self darkBlue];
}

+ (ccColor3B)pipeLayer2Color
{
    return [self darkRed];
}

@end
