#import "FlyingToaster.h"

@implementation FlyingToaster

-(id)init: (NSSize) size
{
    self = [super init];
    
    if ( SSRandomIntBetween( 0, size.width + size.height ) > size.width )
    {
        self.x = size.width + 256;
        self.y = SSRandomIntBetween( 256, size.height );
    }
    else
    {
        self.x = SSRandomIntBetween( 256, size.width );
        self.y = size.height + 256;
    }
    
    self.z = SSRandomFloatBetween( 0, 1 );
    
    self->state = StateFlapping;
    
    self.index = SSRandomIntBetween( 0, 63 );
    
    self->s = SSRandomFloatBetween( 0.8, 1.5 );
    
    return self;
}

-(void)update
{
    self.x = self.x - ( ( 4 * MAX( self.z, 0.4 ) ) * self->s );
    self.y = self.y - ( ( 2 * MAX( self.z, 0.4 ) ) * self->s );
    
    self.index++;
    
    switch ( self->state )
    {
        case StateFlapping:
            
            if ( self.index > 63 )
            {
                if ( SSRandomIntBetween(0, 5) > 1 )
                {
                    self.index = 0;
                }
                else
                {
                    self.index = 64;
                    self->state = StateStartingToCoast;
                }
            }
            
            break;
            
        case StateStartingToCoast:
            
            if ( self.index > 86 )
            {
                self->state = StateCoasting;
            }
            
            break;
            
        case StateCoasting:
            
            if ( self.index > 110 )
            {
                if ( SSRandomIntBetween(0, 5) > 1 )
                {
                    self.index = 86;
                }
                else
                {
                    self.index = 111;
                    self->state = StateFinishingCoast;
                }
            }
            
            break;
            
        case StateFinishingCoast:
            
            if ( self.index > 130 )
            {
                self.index = 0;
                self->state = StateFlapping;
            }
            
            break;
            
        default:
            
            break;
    }
}

@end
