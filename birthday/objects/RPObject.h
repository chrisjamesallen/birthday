 

#import <Foundation/Foundation.h>
#import "RPMesh.h"
#import "RPShader.h"

@interface RPObject : NSObject{
	GLuint normalMatrix;
	GLuint modelviewprojectionmatrix;
}

@property (assign) RPMesh * mesh;
@property (assign) RPShader * shader;
@end
