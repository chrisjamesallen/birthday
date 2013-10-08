//
//  RPShader.h
//  birthday
//
//  Created by Chris Allen on 18/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLProgram.h"



enum
{
 	TEXURE_ONE,
	TEXURE_TWO,
	TEXURE_THREE,
	TEXURE_FOUR,
	TEXURE_FIVE,
    NUM_TEXTURES
};

// Attribute
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
	ATTRIB_TEXCOORDS,
    NUM_ATTRIBUTES
};

enum
{
	MODELVIEWPROJECTIONMATRIX,
    NORMALMATRIX,
	MODELVIEWMATRIX,
    NUM_UNIFORMS
};




@interface RPShader : NSObject{
	GLProgram * program;
   	GLint uniforms[20];
 	GLint attributes[NUM_ATTRIBUTES];
	GLuint normalMatrix;
	GLuint modelviewprojectionmatrix;
}

@property (assign)GLuint modelViewProjectionMatrix;
@property (assign) NSMutableArray * objects;
+(id) shaders;
+(id) shaderForName:(NSString *) name;
+(void) addShader: (RPShader *) shader WithKey: (NSString *) key;
-(void) use;
-(GLint)getAttribute:( int )type;
-(GLint)getUniform:( int )type;
@end
