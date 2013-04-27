//
//  PathUtils.m
//  PipeGame
//
//  Created by John Saba on 4/17/13.
//
//

#import "PathUtils.h"

static NSString *const kDirectoryTilesets = @"tilesets";
static NSString *const kTmx = @".tmx";

@implementation PathUtils {}

#pragma mark - data sources

+ (NSArray *)tileMapNames
{    
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    NSMutableArray *maps = [NSMutableArray array];
    for (id c in contents) {
        if ([c isKindOfClass:[NSString class]]) {
            NSString *name = (NSString *)c;
            if ([[name substringFromIndex:name.length - kTmx.length] isEqualToString:kTmx]) {
                [maps addObject:[name substringToIndex:name.length - kTmx.length]];
            }
        }
    }    
    return maps;
}

@end
