//
//  RPGLView.m
//  birthday
//
//  Created by Chris Allen on 11/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import "RPGLView.h"
#import <OpenGL/OpenGL.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/CVDisplayLink.h>
#import "RPController.h"
void renderCallback(void);



// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(RPGLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

@interface RPGLView(controller)
@property (assign) RPController * controller;
@end


@implementation RPGLView
 

- (void)windowDidResignMain:(NSNotification *)notification {
	NSLog(@"window did resign main");
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
	NSLog(@"window did become main");
}

 
- (void) prepareOpenGL{

	// set custom pixel format attributes
    NSOpenGLPixelFormatAttribute attribs[] =
    {
		kCGLPFAAccelerated,
		kCGLPFANoRecovery,
		kCGLPFADoubleBuffer,
		kCGLPFAColorSize, 24,
		kCGLPFADepthSize, 16,
		NSOpenGLPFAOpenGLProfile,
		//set to open gl 3
		NSOpenGLProfileVersion3_2Core,
		0
    };
	// set pixel format with custom attributes above
    self.pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
	// check for fault
    if (!self.pixelFormat)
		NSLog(@"No OpenGL pixel format");
    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	// this enables alpha in the frame buffer (commented now)
	GLint opaque = 0;
	[[self openGLContext] setValues:&opaque forParameter:NSOpenGLCPSurfaceOpacity];
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
    // Set the display link for the current renderer
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, [[self openGLContext] CGLContextObj], [[self pixelFormat] CGLPixelFormatObj]);
	[self enableGL];
 	[self startAnimation];
	[self.controller start];
}

-(void) enableGL{
	
	CGLLockContext([[self openGLContext] CGLContextObj]);
	[[self openGLContext] makeCurrentContext];
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_TEXTURE_2D);
  	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glOrtho(0.0, 400, 0.0, 400, -1.0, 1.0);
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
	[[self openGLContext] makeCurrentContext];
}


- (void) startAnimation
{
	if (displayLink && !CVDisplayLinkIsRunning(displayLink))
		CVDisplayLinkStart(displayLink);
}


- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self drawView:outputTime];
	[pool release];
    return kCVReturnSuccess;
}


- (void) drawRect:(NSRect)dirtyRect
{
	[[NSColor clearColor] set];
	 NSRectFill(dirtyRect);
	// Ignore if the display link is still running
	if (!CVDisplayLinkIsRunning(displayLink))
		[self drawView:nil];
}


- (void)drawView:(const CVTimeStamp*) timeStamp {
	// lock context as is on display thread
	CGLLockContext([[self openGLContext] CGLContextObj]);
	// make sure we draw to the right context
	[[self openGLContext] makeCurrentContext];
	// erase the screen
	glClear(GL_COLOR_BUFFER_BIT);				
 	// draw operations
	[self drawTestTriangle];
	// tell controller to render
	[((RPController *)self.controller) render];
	// and flush baby!
	[[self openGLContext] flushBuffer];
	// log out any errors on flush
    int err;
    if ((err = glGetError()) != 0)
        NSLog(@"glGetError(): %d", err);
	// unlock context
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}


- (void)drawTestTriangle{
	//draw
	glMatrixMode(GL_MODELVIEW);	// use model matrix
	glLoadIdentity();			// reset matrix
	glOrtho(0.0, 400.0, 0.0, 400.0, -1.0, 1.0);	// we reset, so setup coords again
	glTranslatef(200, 200, 0);		// move to where we want to draw the triangle
	glBegin(GL_TRIANGLES);
	glColor3f(1.0f,0.0f,0.0f);
	glVertex3i(0, -100, 0);
	glColor3f(0.0f,1.0f,0.0f);
	glVertex3i(100, 100, 0);
	glColor3f(0.0f,0.0f,1.0f);
	glVertex3i(-100, 100, 0);
	glEnd();
	glFinish();
}
 
- (BOOL)acceptsFirstResponder {
    return YES;
}



- (void)reshape {
//apply resize here....
    // window resize; width and height are in pixel coordinates
//    float screen_w = [self frame].size.width;
//    float screen_h = [self frame].size.height;
    //screen_resize((int)screen_w, (int)screen_h);
}





- (void) stopAnimation
{
	if (displayLink && CVDisplayLinkIsRunning(displayLink))
		CVDisplayLinkStop(displayLink);
}

- (void)dealloc{
	// Release the display link
	CVDisplayLinkStop(displayLink);
    CVDisplayLinkRelease(displayLink);
	[super dealloc];
}

@end
