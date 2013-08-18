 

#import "GLProgram.h"


@interface GLProgram(){
 GLuint _program;
}

 
@end



#pragma mark - INIT

@implementation GLProgram

- (BOOL)loadShaders:(NSString *) name
{
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and copile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
	 
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
//    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
//    glBindAttribLocation(program, ATTRIB_NORMAL, "normal");
//    
//    // Link program.
//    if (![self link]) {
//        NSLog(@"Failed to link program: %d", program);
//        
//        if (vertShader) {
//            glDeleteShader(vertShader);
//            vertShader = 0;
//        }
//        if (fragShader) {
//            glDeleteShader(fragShader);
//            fragShader = 0;
//        }
//        if (_program) {
//            glDeleteProgram(_program);
//            _program = 0;
//        }
//        
//        return NO;
//    }
    
    // Get uniform locations.
//    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
//    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
//    // Release vertex and fragment shaders.
//    if (vertShader) {
//        glDetachShader(_program, vertShader);
//        glDeleteShader(vertShader);
//    }
//    if (fragShader) {
//        glDetachShader(_program, fragShader);
//        glDeleteShader(fragShader);
//    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    NSString * BLAH = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)link
{
    GLint status;
    glLinkProgram(program);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == 0) {
		NSLog(@"Failed to link program: %d", program);
        return NO;
    }
    
    return YES;
}

- (BOOL)validate
{
    GLint logLength, status;
    
    glValidateProgram(program);
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(program, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


-(void) use{
	glUseProgram(program);
}

 
- (void)dealloc
{
 
    if (vertShader)
        glDeleteShader(vertShader);
	
    if (fragShader)
        glDeleteShader(fragShader);
    
    if (program)
        glDeleteProgram(program);
	NSLog(@"dealloc program");
}
// END:dealloc
@end
