//
//  RPGLView.h
//  birthday
//
//  Created by Chris Allen on 11/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>



@interface RPGLView : NSOpenGLView <NSWindowDelegate>
{
	CVDisplayLinkRef displayLink;
}
@property (assign) id controller;
- (void) prepareOpenGL;
- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime;
@end
