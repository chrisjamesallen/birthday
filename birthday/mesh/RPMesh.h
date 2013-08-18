#import "obj3_shader.h"




@interface obj3Mesh  : NSObject  {
 	GLuint vbo;
	GLuint vao_;
	int count;
	obj3Shader * shader;
	GLfloat (*meshPointer)[];
	int stride;
	long vertices;
	long dataSize;
}

+(obj3Mesh*)disney;
+(obj3Mesh *) skybox;
-(void) prepare;
-(void)draw;
@property (assign)GLfloat  vertices_count;
 
@end