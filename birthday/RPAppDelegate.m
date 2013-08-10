//
//  RPAppDelegate.m
//  birthday
//
//  Created by Chris Allen on 10/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import "RPAppDelegate.h"

@implementation RPAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	NSWindow * window = self.window;
	[window setOpaque:NO];
	NSColor * transparent = [NSColor colorWithCalibratedWhite:1.0 alpha:0.0];
	[window setBackgroundColor:transparent];

	//set max screen
	NSScreen * screen = [NSScreen mainScreen];
	CGRect frame = screen.frame;
	[window setFrame:frame display:YES];
	
	//put at front
	//[window orderFrontRegardless];
	//[NSApp activateIgnoringOtherApps:YES];
	
	[window setLevel:NSScreenSaverWindowLevel + 1];
	[window orderFront:nil];
	
}

@end
