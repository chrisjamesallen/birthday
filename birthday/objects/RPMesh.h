
#import <OpenGL/OpenGL.h>
#import <Foundation/Foundation.h>
#import "RPShader.h"


@interface RPMesh : NSObject {
	GLuint vbo;
	GLuint vao_;
	int count;
	GLfloat (*meshPointer)[];
	RPShader * shader;
	int stride;
	long vertices;
	long dataSize;
}

+(RPMesh*)disney;
+(RPMesh*) skybox;
-(void) prepare;
-(void)draw;
@property (assign)GLfloat  vertices_count;

@end
