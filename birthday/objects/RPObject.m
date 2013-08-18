
#import "RPObject.h"
#import "RPMesh.h"
#import "RPShader.h"


@implementation RPObject
@synthesize mesh;

-(id) init;
{
	self = [super init];
	if(self != nil)
	{
		self.mesh = [RPMesh disney];
 		self.shader = [RPShader shaderForName:@"Basic"];
	}
	return self;
}


@end
