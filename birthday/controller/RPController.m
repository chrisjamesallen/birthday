#import "RPController.h"
#import "RPObject.h"

@implementation RPController

@synthesize  view,shaders;


- (void) start {
	[self.view prepareOpenGL];
	[self prewarmObjects];
}

- (void) prewarmObjects {
	//lets make an object
	//[[RPObject alloc] init];
}

- (void) render {
	//iterate through each shader
	for(id shader in self.shaders){
		//iterate through each object
		for(id object in shader){
			[object render];
		}
	}
}


@end