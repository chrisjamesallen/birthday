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

+(id) shaderForName:(NSString *) name {
	RPShader * shader= [shaders objectForKey:name];
	if(shader == nil){
		shader = [[RPShader alloc] initWithName:name];
		[RPShader addShader:shader WithKey:name];
	}
	return [shaders objectForKey:name];
}

+(void) addShader: (RPShader *) shader WithKey: (NSString *) key {
	if(shaders == nil){
		shaders = [[NSMutableDictionary alloc] init];
	}
	[shaders insertValue:shaders inPropertyWithKey:key];
}

-(id) initWithName:(NSString *) name;
{
	self = [super init];
	if(self != nil)
	{
 		program = [[GLProgram alloc] init];
		[program loadShaders:name];
		[RPShader addShader:self WithKey:name];
	}
	return self;
}

- (void)dealloc
{
    [program release];
    [super dealloc];
}

@end
