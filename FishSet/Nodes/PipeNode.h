//
//  PipeNode.h
//  FishSet
//
//  Created by John Saba on 2/6/13.
//
//

#import "CellNode.h"

typedef enum
{
    kPipeExitsCornerUpRight = 0,
    kPipeExitsCornerUpLeft,
    kPipeExitsCornerDownRight,
    kPipeExitsCornerDownLeft,

    kPipeExits3WayUp,
    kPipeExits3WayRight,
    kPipeExits3WayDown,
    kPipeExits3WayLeft,
    
    kPipeExits4Way,
    
    kPipeExitsDeadEndUp,
    kPipeExitsDeadEndRight,
    kPipeExitsDeadEndDown,
    kPipeExitsDeadEndLeft,
    
    kPipeExitsHorizontal,
    kPipeExitsVertical,
        
} kPipeExits;

@interface PipeNode : CellNode



@end
