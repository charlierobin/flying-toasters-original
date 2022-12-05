#import "FlyingToastersView.h"

@implementation FlyingToastersView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        GLint aValue = 0;

        [self.openGLContext setValues:&aValue forParameter:NSOpenGLContextParameterSurfaceOpacity];
        
        [NSTimer scheduledTimerWithTimeInterval: SSRandomFloatBetween(0.5, 1.0) target: self selector:@selector(createNew:) userInfo: nil repeats:NO];
        
        self->toasters = [[NSMutableArray alloc] init];
        self->toDelete = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)createNew: (NSTimer*)theTimer
{
    if ( self->toasters.count < 100 )
    {
        FlyingToaster * toaster = [[FlyingToaster alloc] init: self.frame.size];
        
        [self->toasters addObject:toaster];
        
        [self->toasters sortUsingComparator: ^NSComparisonResult(FlyingToaster* t1, FlyingToaster* t2)
         {
            if (t1.z > t2.z) return NSOrderedDescending;
            
            if (t1.z < t2.z) return NSOrderedAscending;
            
            return NSOrderedSame;
        }];
    }
    
    [NSTimer scheduledTimerWithTimeInterval: SSRandomFloatBetween(0.5, 1.0) target: self selector:@selector(createNew:) userInfo: nil repeats:NO];
}

-(void)loadNSImage:(NSImage*)inputImage intoTexture:(GLuint)glTexture
{
    // https://stackoverflow.com/questions/22761467/most-efficient-way-to-gltexture-from-nsimage
    
    glBindTexture(GL_TEXTURE_2D, glTexture);
    
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:[inputImage TIFFRepresentation]];
    
    glPixelStorei(GL_UNPACK_ROW_LENGTH, (GLint)[bitmap pixelsWide]);
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    NSInteger samplesPerPixel = [bitmap samplesPerPixel];
    
    if ( ! [ bitmap isPlanar ] && ( samplesPerPixel == 3 || samplesPerPixel == 4 ) )
    {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLint)[bitmap pixelsWide], (GLint)[bitmap pixelsHigh], 0, GL_RGBA, GL_UNSIGNED_BYTE, [bitmap bitmapData]);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
    }
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glMatrixMode( GL_PROJECTION );
    glLoadIdentity();

    glOrtho( 0, self.frame.size.width, 0, self.frame.size.height, 0, 100 );

    glMatrixMode( GL_MODELVIEW );
    glLoadIdentity();
    
    glClearColor( 0, 0, 0, 0 );
    
    glEnable( GL_TEXTURE_2D );
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    for (int frameNumber = 0; frameNumber <= 130; frameNumber++)
    {
        GLuint t;
        
        glGenTextures( 1, &t );
        
        NSString *fileName = [NSString stringWithFormat:@"frames/toaster_%04d", frameNumber];
        
        NSString* filepathString = [[NSBundle bundleForClass: [self class]] pathForResource:fileName ofType:@"png"];
        
        NSImage *theImage = [[NSImage alloc] initWithContentsOfFile: filepathString];
        
        [self loadNSImage:theImage intoTexture: t];
        
        self->textureNames[ frameNumber ] = t;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    for ( FlyingToaster * toaster in self->toasters )
    {
        float s = MAX( toaster.z, 0.4 );
        
        glColor4f( s, s, s, 1 );

        glBindTexture( GL_TEXTURE_2D, self->textureNames[ toaster.index ] );
        
        glPushMatrix();

        glTranslatef( toaster.x, toaster.y, 0 );

        s = s * 200;

        glScalef( s, s, s );

        glBegin( GL_QUADS );

        glTexCoord2f( 0.0, 0.0 );
        glVertex3i( -1.0, 1.0, 0.0 );

        glTexCoord2f( 0.0, 1.0 );
        glVertex3i( -1.0, -1.0, 0.0 );

        glTexCoord2f( 1.0, 1.0 );
        glVertex3i( 1.0, -1.0, 0.0 );

        glTexCoord2f( 1.0, 0.0 );
        glVertex3i( 1.0, 1.0, 0.0 );

        glEnd();

        glPopMatrix();
    }
    
    glFlush();
}

- (void)animateOneFrame:(NSTimer*)t
{
    FlyingToaster * toaster;
    
    for ( toaster in self->toasters )
    {
        [toaster update];
        
        if ( toaster.x < -256 || toaster.y < -256 )
        {
            [self->toDelete addObject: toaster];
        }
    }
    
    for ( toaster in self->toDelete )
    {
        [self->toasters removeObject:toaster];
    }
    
    [self->toDelete removeAllObjects];
    
    [self setNeedsDisplay:YES];
}

@end
