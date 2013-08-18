
#import "obj3_mesh.h"
#import "meshes.h" 
#define BUFFER_OFFSET(i)((char *)NULL + (i))
#import <GLKit/GLKit.h>
#import "disney.h"

@implementation obj3Mesh
@synthesize vertices_count;
 

+(obj3Mesh*)skybox{
 	obj3Mesh * obj = [[obj3Mesh alloc]init];
	obj->meshPointer = (GLfloat (*)[]) MESH_SKYBOX_DATA;
	obj->stride = 8;//How many values per column/vertex of data
	obj->vertices = ( sizeof(MESH_SKYBOX_DATA) / sizeof(GLfloat) ) / obj->stride;
	obj->dataSize = sizeof(GLfloat) *  obj->stride  * obj->vertices;
	[obj createVao];
	return obj;
}


+(obj3Mesh*)disney{
 	obj3Mesh * obj = [[obj3Mesh alloc]init];
	obj->meshPointer = (GLfloat (*)[]) MESHDISNEY;
	obj->stride = 8;//How many values per column/vertex of data
	obj->vertices = ( sizeof(MESHDISNEY) / sizeof(GLfloat) ) / obj->stride;
	obj->dataSize = sizeof(GLfloat) *  obj->stride  * obj->vertices;
	[obj createVao];
	return obj;
}

+(obj3Mesh*)plane{
 	obj3Mesh * obj = [[obj3Mesh alloc]init];
	obj->meshPointer = (GLfloat (*)[]) MESH_PLANE_DATA;
	obj->stride = 8;//How many values per column/vertex of data
	obj->vertices = ( sizeof(MESH_PLANE_DATA) / sizeof(GLfloat) ) / obj->stride;
	obj->dataSize = sizeof(GLfloat) *  obj->stride  * obj->vertices;
	[obj createVao];
	return obj;
}

+(obj3Mesh*)ball{
 	obj3Mesh * obj = [[obj3Mesh alloc]init];
	obj->meshPointer = (GLfloat (*)[]) MESH_BALL_DATA;
	obj->stride = 8;//How many values per column/vertex of data
	obj->vertices = ( sizeof(MESH_BALL_DATA) / sizeof(GLfloat) ) / obj->stride;
	obj->dataSize = sizeof(GLfloat) *  obj->stride  * obj->vertices;
	[obj createVao];
	return obj;
}



-(void)createvbo{
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
 	glBufferData(GL_ARRAY_BUFFER, dataSize, self->meshPointer, GL_STATIC_DRAW);
}

-(void)createVao{
//todo glDeleteVertexArraysOES


	glGenVertexArraysOES(1, &vao_);
	glBindVertexArrayOES(vao_);
	
	[self createvbo];

	glEnableVertexAttribArray( GLKVertexAttribPosition);
	glVertexAttribPointer( GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, (4 * 8), BUFFER_OFFSET(4*0));

	glEnableVertexAttribArray( GLKVertexAttribNormal );
	glVertexAttribPointer( GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, (4 * 8), BUFFER_OFFSET(4*3));

	glBindVertexArrayOES(0);

	
	
}

-(void)prepare{
	//this calls vao
	glBindVertexArrayOES(vao_);
}

-(void)draw{

	
//	NSTimeInterval planeStart = [NSDate timeIntervalSinceReferenceDate];

	glDrawArrays(GL_TRIANGLES, 0, vertices);
	
	
//	NSTimeInterval planeEnd = [NSDate timeIntervalSinceReferenceDate];
//	NSLog(@"End Load of mesh at %f", planeEnd);
//	NSLog(@"Duration: %f", planeEnd - planeStart);
}

 
-(void) dealloc
{
	//todo glDeleteVertexArraysOES
	NSLog(@"dealloc mesh");
}

 
//	const GLfloat (*mesharraypointer)[288] =  (GLfloat (*)[]) MESH_SKYBOX_DATA;
@end;