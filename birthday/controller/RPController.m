#import "RPController.h"
#import "RPObject.h"
#import "RPShader.h"
@implementation RPController

@synthesize  view,shaders;


- (void) start {
	[self prewarmObjects];
}

- (void) prewarmObjects {
	//lets make an object
	[[RPObject alloc] init];
}

- (void) render {
	//iterate through each shader
	for(RPShader * shader in [[RPShader shaders] allValues]){
		//iterate through each object
		[shader use];
		for(id object in shader.objects){
			[object render];
		}
	}
}


@end