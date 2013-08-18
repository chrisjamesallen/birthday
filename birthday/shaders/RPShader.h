//
//  RPShader.h
//  birthday
//
//  Created by Chris Allen on 18/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLProgram.h"

@interface RPShader : NSObject{
	GLProgram * program;
}
+(id) shaderForName:(NSString *) name;
+(void) addShader: (RPShader *) shader WithKey: (NSString *) key;
@end
