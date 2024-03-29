//
//  OpenGLTexture3D.h
//  NeHe Lesson 06
//
//  Created by Jeff LaMarche on 12/24/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>
 

@interface GLTexture : NSObject {
	GLuint		texture[1];  
	NSString	*filename;
}
@property (nonatomic, retain)NSString *filename;
- (id)initWithFilename:(NSString *)filename;
- (void)use;
+ (void)useDefaultTexture;
@end
