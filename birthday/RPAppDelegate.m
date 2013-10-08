//
//  RPAppDelegate.m
//  birthday
//
//  Created by Chris Allen on 10/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import "RPAppDelegate.h"
#import "RPGLView.h"


@implementation RPAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	NSWindow * window = self.window;
	// Create NSOpenGLView
	self.glView = [[RPGLView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	// Add view
	[window setContentView:self.glView];
	// force draw
	[self.glView setNeedsDisplay:YES];
	// delegate to allow notifications
	window.delegate = self.glView;
	// make transparent
	[window setOpaque:NO];
	NSColor * transparent = [NSColor colorWithCalibratedWhite:1.0 alpha:0.0];
	[window setBackgroundColor:transparent];
	//set size to max screen
	NSScreen * screen = [NSScreen mainScreen];
	CGRect frame = screen.frame;
	[window setFrame:frame display:YES];
	//init controller
	RPController * controller = [[RPController alloc] init];
 	self.glView.controller = controller;
}

@end
