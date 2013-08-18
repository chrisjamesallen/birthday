//
//  RPAppDelegate.h
//  birthday
//
//  Created by Chris Allen on 10/08/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>
#import "RPGLView.h"
#import "RPController.h"

@interface RPAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView * view;
@property (assign) RPGLView * glView;

@end
