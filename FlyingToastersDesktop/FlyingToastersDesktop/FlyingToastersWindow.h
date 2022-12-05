#import <Cocoa/Cocoa.h>

#import "FlyingToastersView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyingToastersWindow : NSWindow
{
    FlyingToastersView * view;
    
    NSTimer * timer;
}
@end

NS_ASSUME_NONNULL_END
