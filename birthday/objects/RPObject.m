
#import "RPObject.h"
#import "RPMesh.h"
#import "RPShader.h"
#import <GLKit/GLKit.h>


@interface RPObject(){   
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@end

@implementation RPObject
@synthesize mesh;

-(id) init;
{
	self = [super init];
	if(self != nil)
	{
		self.mesh = [RPMesh disney];
 		self.shader = [RPShader shaderForName:@"Basic"];
		[self.shader.objects addObject:self];
	}
	return self;
}

-(void)render {
	[self update];
	[self.mesh prepare];
  	glUniformMatrix4fv( [self.shader getUniform:MODELVIEWPROJECTIONMATRIX], 1, 0, _modelViewProjectionMatrix.m);
	glUniformMatrix3fv( [self.shader getUniform:NORMALMATRIX], 1, 0, _normalMatrix.m);
	[self.mesh draw];
	
}


-(void)update{
	//NSLog(@"update object");
    float aspect = 0.75f;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 800.0f);
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -20.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, -7.0f, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, 1.57, 1.0f, 0.0f, 0.0f);
	modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.2, 0.2, 0.2);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    _rotation += 0.01f;
	
}

@end
