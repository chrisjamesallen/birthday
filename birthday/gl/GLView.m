
#import "GLView.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
  

@implementation GLView
@synthesize  context,outsideRect,scale;


#pragma mark - INIT
 
//INIT //OVERIDE
+(Class)layerClass/* overide */{
	return [CAEAGLLayer class];
}

//INIT 
-(id)initWithFrame:(CGRect)rect withmsaa:(bool) with_msaa /* public */{
    self = [super initWithFrame:rect];
    if (self)
	{
        // Initialization code.
		withMSAA = with_msaa;
 	}
	
	return self;
}

//INIT 
-(void)setupGL/* public */{
	if(self.context !=nil)return;
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties =  
	[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], 
	 kEAGLDrawablePropertyRetainedBacking, 
	 kEAGLColorFormatRGB565, 
	 kEAGLDrawablePropertyColorFormat, nil];
	
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	animating = FALSE;
	
	if (!self.context || ![EAGLContext setCurrentContext:self.context] || ![self createFramebuffers] ){
		//debug(@"Failed creating context");
		return;
	}
	
}

//INIT 
-(void)setAsMainContext:(EAGLContext * )context/* public */{
	
	[EAGLContext setCurrentContext:self.context];
	if(withMSAA){
		glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	}else{
		glBindRenderbuffer(GL_RENDERBUFFER, offscreenRenderbuffer);
	}
	
}

//INIT
-(BOOL)createFramebuffers;{	
	//glEnable(GL_DEPTH_TEST);
	glClear(GL_COLOR_BUFFER_BIT);

	
	
	if(withMSAA)
	{	
		/* Create fbo with msaa */
		glGenFramebuffers(1, &viewFramebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
		
		glGenRenderbuffers(1, &viewRenderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
		
		//... note this is a convience from glRenderbufferStorage as it designates size taken from calayer 
		[self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer]; 			
		
		//... note because the width and hieght is determined from caeagllayer view's bound and scale, 
		// the width and hight below is setted, viewport is set using these variables
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);	
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
		
		// Multisampled antialiasing
		// 1. Create Offscreen framebuffer obj
		
		glGenFramebuffers(1, &msaaFramebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, msaaFramebuffer);
		
		//2. Now attach offscreen render buffer
		
		glGenRenderbuffers(1, &msaaRenderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, msaaRenderbuffer);
		
		//Render Buffer 4X MSAA storage then attach render buffer to msaaframebuffer
		
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, backingWidth, backingHeight); 
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, msaaRenderbuffer); 
		
		//Depth Buffer Add 4x msaa storage
		
		glGenRenderbuffers(1, &msaaDepthbuffer);   
		glBindRenderbuffer(GL_RENDERBUFFER, msaaDepthbuffer); 
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16, backingWidth, backingHeight); 
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, msaaDepthbuffer);
		
	}else{
		
		/* Create fbo without msaa */
		
		//1. Create Offscreen framebuffer object
		
		glGenFramebuffers(1, &offscreenFramebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, offscreenFramebuffer);
		
		//2. Now attach offscreen render buffer
		
		glGenRenderbuffers(1, &offscreenRenderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, offscreenRenderbuffer);
		
		//... note this is a convience from glRenderbufferStorage as it designates size taken from calayer 
		[self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer]; 			
		
		//... note because the width and hieght is determined from caeagllayer view's bound and scale, 
		// the width and hight below is setted, viewport is set using these variables
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);	
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, offscreenRenderbuffer);
		
		//3. Now attach Offscreen Depth Buffer object
		
		//glGenRenderbuffers(1, &offscreenDepthBuffer);
		//glBindRenderbuffer(GL_RENDERBUFFER, offscreenDepthBuffer);
		//glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
		//glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, offscreenDepthBuffer);
		
	}	
	
 	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE){
		//debug(@"Incomplete FBO: %d", glCheckFramebufferStatus(GL_FRAMEBUFFER) );
 	}
	
	glViewport(0, 0, backingWidth, backingHeight);
 	glClear(GL_COLOR_BUFFER_BIT);
	
	//debug(@"backingWidth %i backingheight %i", backingWidth,backingHeight);
	
 	return YES;
}






#pragma mark - PRESENTBUFFERS
//*************************************************** 
//	PRESENTBUFFERS
//*************************************************** 

//PRESENTBUFFERS
	-(void)clearFrameBuffer;/* public */{
		[EAGLContext setCurrentContext:self.context];
		glClear(  GL_COLOR_BUFFER_BIT );
 
	}
//PRESENTBUFFERS
	-(BOOL)presentFramebuffer;/* public */{
		BOOL success = FALSE;
		[EAGLContext setCurrentContext:self.context];
		if (self.context)
		{
			if(withMSAA){
				glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, msaaFramebuffer); 
				glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, viewFramebuffer);
 				const GLenum discards[] = {  GL_COLOR_ATTACHMENT0 };
				glDiscardFramebufferEXT(GL_FRAMEBUFFER, 1, discards);
 				glResolveMultisampleFramebufferAPPLE();
 				glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
				success = [self.context presentRenderbuffer:GL_RENDERBUFFER];
				glBindFramebuffer(GL_FRAMEBUFFER, msaaFramebuffer);
 			}else{
 				const GLenum discards[] = {  GL_COLOR_ATTACHMENT0 };
				glDiscardFramebufferEXT(GL_FRAMEBUFFER, 1, discards);
				glBindRenderbuffer(GL_RENDERBUFFER, offscreenRenderbuffer);  			
				success = [self.context presentRenderbuffer:GL_RENDERBUFFER];
				//glBindFramebuffer(GL_FRAMEBUFFER, offscreenFramebuffer);
				
			}
		}
		return success;
	}
//PRESENTBUFFERS
	-(void)switchToDisplayFramebuffer;/* public */{
		glViewport(0, 0, backingWidth, backingHeight);
		if(withMSAA){
			glBindFramebuffer(GL_FRAMEBUFFER, msaaFramebuffer); 
		}else {
			glBindFramebuffer(GL_FRAMEBUFFER, offscreenFramebuffer);
		}
		
	}
//PRESENTBUFFERS
	-(void)clearScreen/* public */{
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		const CGFloat myColor[] = {0.0, 0.0, 0.0, 0.0};
		CGColorRef rgbref =CGColorCreate(rgb, myColor);
		eaglLayer.backgroundColor = rgbref;
		CGColorSpaceRelease(rgb);
		CGColorRelease(rgbref);
	}







#pragma mark - CLOSEDOWN
//*************************************************** 
//	CLOSEDOWN
//*************************************************** 

	-(void)tearDownGL;{	
	
		[EAGLContext setCurrentContext:self.context];

		if(withMSAA){
			glDeleteFramebuffers(1, &viewFramebuffer);
			viewFramebuffer = 0;
			
			glDeleteRenderbuffers(1, &viewRenderbuffer);
			viewRenderbuffer = 0;
			
			glDeleteRenderbuffers(1, &depthRenderbuffer);
			depthRenderbuffer = 0; 
			
			glDeleteFramebuffers(1, &msaaFramebuffer);
			msaaFramebuffer = 0;
			
			glDeleteRenderbuffers(1, &msaaRenderbuffer);
			msaaRenderbuffer = 0;
			
			glDeleteRenderbuffers(1, &msaaDepthbuffer);
			msaaDepthbuffer = 0;
			
		}else{
			
			glDeleteFramebuffers(1, &offscreenFramebuffer);
			offscreenRenderbuffer = 0;
			
			glDeleteRenderbuffers(1, &offscreenRenderbuffer);
			offscreenRenderbuffer = 0;
			
			glDeleteRenderbuffers(1, &offscreenDepthBuffer);
			offscreenDepthBuffer = 0;
			
		}  
		
	}

	-(void)dealloc{
		[self tearDownGL];
		self.context = nil;
		//debug(@"dealloc glviewer");
	}




@end
