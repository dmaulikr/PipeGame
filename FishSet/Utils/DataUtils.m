//
//  DataUtils.m
//  FishSet
//
//  Created by John Saba on 1/19/13.
//
//

#import "DataUtils.h"

static NSString *const kPuzzlesPlist = @"Puzzles";
static NSString *const kPuzzlesPlistEntryCoordX = @"entry coord.x";
static NSString *const kPuzzlesPlistEntryCoordY = @"entry coord.y";
static NSString *const kPuzzlesPlistEntryDirection =@"entry direction";
static NSString *const kPuzzlesPlistSizeX = @"size.x";
static NSString *const kPuzzlesPlistSizeY = @"size.y";

@implementation DataUtils

+ (NSData *)plistXML:(NSString *)plist
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[plist stringByAppendingString:@".plist"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    }
    return [[NSFileManager defaultManager] contentsAtPath:plistPath];
}

+ (NSDictionary *)plistDictionary:(NSString *)plist
{
    NSData *plistXML = [DataUtils plistXML:plist];
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *plistDict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (plistDict == nil) {
        NSLog(@"warning: plist == nil, error: %@, format: %d", errorDesc, format);
    }    
    return plistDict;
}

+ (NSArray *)plistArray:(NSString *)plist
{
    NSData *plistXML = [DataUtils plistXML:plist];
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSArray *plistArray = (NSArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (plistArray == nil) {
        NSLog(@"warning: plist == nil, error: %@, format: %d", errorDesc, format);
    }
    return plistArray;
}

// return puzzle data from plist, 0-based index
+ (NSDictionary *)puzzleData:(NSUInteger)puzzleNumber
{
    NSArray *plist = [DataUtils plistArray:kPuzzlesPlist];
    NSDictionary * puzzle = [plist objectAtIndex:puzzleNumber];
    return puzzle;
}

// entry coordinate for puzzle
+ (GridCoord)puzzleEntryCoord:(NSUInteger)puzzleNumber
{
    NSDictionary *puzzle = [DataUtils puzzleData:puzzleNumber];
    NSNumber *x = [puzzle valueForKeyPath:kPuzzlesPlistEntryCoordX];
    NSNumber *y = [puzzle valueForKeyPath:kPuzzlesPlistEntryCoordY];
    return GridCoordMake([x intValue], [y intValue]);
}

// entry coordinate for puzzle
+ (GridCoord)puzzleSize:(NSUInteger)puzzleNumber
{
    NSDictionary *puzzle = [DataUtils puzzleData:puzzleNumber];
    NSNumber *x = [puzzle valueForKeyPath:kPuzzlesPlistSizeX];
    NSNumber *y = [puzzle valueForKeyPath:kPuzzlesPlistSizeY];
    return GridCoordMake([x intValue], [y intValue]);
}

// direction hand enters puzzle, value 'right' would mean it enters to the right coming from the left side of a cell
+ (kDirection)puzzleEntryDireciton:(NSUInteger)puzzleNumber
{
    NSDictionary *puzzle = [DataUtils puzzleData:puzzleNumber];
    NSNumber *direction = [puzzle valueForKeyPath:kPuzzlesPlistEntryDirection];
    return [direction intValue];
}

@end
