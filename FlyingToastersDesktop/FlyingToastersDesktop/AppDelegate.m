#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // https://stackoverflow.com/questions/314256/how-do-i-create-a-cocoa-window-programmatically
    
    self->windows = [[NSMutableArray alloc] init];
    
    NSArray * screenArray = [NSScreen screens];
    
//    self.height = 100;
    
    for ( NSScreen * screen in screenArray )
    {
        FlyingToastersWindow* w = [[FlyingToastersWindow alloc] initWithContentRect: [screen frame] styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
        
        [w setOpaque:NO];
        [w setBackgroundColor:[NSColor clearColor]];
        [w makeKeyAndOrderFront:NSApp];
        
        [ self->windows addObject: w ];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
