#import <ScreenSaver/ScreenSaver.h>

#import <OpenGL/gl.h>

#import "FlyingToaster.h"

@interface FlyingToastersView : NSOpenGLView
{
    NSMutableArray* toasters;
    NSMutableArray* toDelete;
    
    GLuint textureNames[ 131 ];
}

- (void)animateOneFrame:(NSTimer*)t;

@end
