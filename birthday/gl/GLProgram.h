//  This is Jeff LaMarche's GLProgram OpenGL shader wrapper class from his OpenGL ES 2.0 book.
//  A description of this can be found at his page on the topic:
//  http://iphonedevelopment.blogspot.com/2010/11/opengl-es-20-for-ios-chapter-4.html


#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLProgram : NSObject
{
    NSMutableArray  *attributess;
    NSMutableArray  *uniformss;
@public
	GLuint vertShader, program,
	fragShader;
	NSString *shadername;
}
- (BOOL)loadShaders:(NSString *) name;
- (BOOL)link;
- (BOOL)validate;
- (void)use;
@end
