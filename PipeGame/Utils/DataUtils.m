//
//  DataUtils.m
//  PipeGame
//
//  Created by John Saba on 1/19/13.
//
//

#import "DataUtils.h"

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

@end
