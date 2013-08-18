 
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>//For MSAA
 #import "GLProgram.h"



@interface GLView : UIView 
{
	int withMSAA;
	GLint backingWidth, backingHeight;
	EAGLContext *context;
	BOOL animating;
	float red,green,blue;
 	//MSAA Buffers
	GLuint  viewRenderbuffer, 
			viewFramebuffer, 
			depthRenderbuffer, 
			msaaFramebuffer, 
			msaaRenderbuffer, 
			msaaDepthbuffer;
	//NON MSAA Buffers		
	GLuint offscreenRenderbuffer, offscreenFramebuffer, offscreenDepthBuffer;
}
@property (nonatomic,assign)float scale;
@property (nonatomic,assign)CGRect outsideRect;
@property (nonatomic,retain)EAGLContext *context;
+(Class)layerClass;
-(id)initWithFrame:(CGRect)rect withmsaa:(bool) with_msaa/* public */;
-(void)setupGL/* public */;
-(void)setAsMainContext:(EAGLContext * )context/* public */;
-(void)clearFrameBuffer/* public */;
-(BOOL)presentFramebuffer/* public */;
-(void)switchToDisplayFramebuffer/* public */;
-(void)clearScreen/* public */;

@end







 


