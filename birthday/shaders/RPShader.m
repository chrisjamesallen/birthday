//
//  RPShader.m
//  birthday
//
//  Created by Chris Allen on 18/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import "RPShader.h"
static NSMutableDictionary * shaders;

@implementation RPShader

+(id) shaders {
	return shaders;
}

+(id) shaderForName:(NSString *) name {
	RPShader * shader = [shaders objectForKey:name];
	if(shader == nil){
		shader = [[RPShader alloc] initWithName:name];
		[RPShader addShader:shader WithKey:name];
	}
	return shader;
}

+(void) addShader: (RPShader *) shader WithKey: (NSString *) key {
	if(shaders == nil){
		shaders = [[NSMutableDictionary alloc] init];
	}
	[shaders setObject:shader forKey:key];
}

-(id) initWithName:(NSString *) name;
{
	self = [super init];
	if(self != nil)
	{
 		program = [[GLProgram alloc] init];
		[program loadShaders:name];
		[RPShader addShader:self WithKey:name];
		self.objects = [[NSMutableArray alloc] init];
		
		self.objects = [[NSMutableArray alloc] init];
		// Init Uniform and Attribute locations
		
		glBindAttribLocation(program->program, ATTRIB_VERTEX, "position");
		glBindAttribLocation(program->program, ATTRIB_NORMAL, "normal");		
		modelviewprojectionmatrix = glGetUniformLocation(program->program, "modelViewProjectionMatrix");
		normalMatrix = glGetUniformLocation(program->program, "normalMatrix");
		uniforms[MODELVIEWPROJECTIONMATRIX] = modelviewprojectionmatrix;
		uniforms[NORMALMATRIX] = normalMatrix;
		
	}
	return self;
}

-(void) use{
	[program use];
}

-(GLint)getAttribute:( int )type;
{
	return attributes[type];
}


-(GLint)getUniform:( int )type;
{
	return uniforms[type];
}



- (void)dealloc
{
    [program release];
    [super dealloc];
}

@end
