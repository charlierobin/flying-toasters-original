#import <Foundation/Foundation.h>

#import <ScreenSaver/ScreenSaver.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    StateFlapping,
    StateStartingToCoast,
    StateCoasting,
    StateFinishingCoast
    
} State;

@interface FlyingToaster : NSObject
{
    float s;

    State state;
}

-(id)init: (NSSize) size;
-(void)update;

@property float x;
@property float y;
@property float z;

@property int index;

@end

NS_ASSUME_NONNULL_END
