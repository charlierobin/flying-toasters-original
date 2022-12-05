#import "FlyingToastersWindow.h"

@implementation FlyingToastersWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    
    if (self)
    {
        [self setLevel:kCGDesktopWindowLevel - 1];
        
        [self setCollectionBehavior: (NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorIgnoresCycle)];
        
        [self orderBack:self];
        
        self->view = [[FlyingToastersView alloc] initWithFrame: contentRect];
        
        [self setContentView: self->view];
        
        self->timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / 30 target: self->view selector:@selector(animateOneFrame:) userInfo: nil repeats:YES];
    }
    
    return self;
}

- (BOOL)canBecomeMainWindow
{
    return NO;
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

@end
