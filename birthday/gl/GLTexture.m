//
//  OpenGLTexture3D.m
//  NeHe Lesson 06
//
//  Created by Jeff LaMarche on 12/24/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import "GLTexture.h"


@implementation GLTexture
@synthesize filename;

- (id)initWithFilename:(NSString *)inFilename
{
	if ((self = [super init]))
	{
		glEnable(GL_TEXTURE_2D);//*
		glDisable(GL_BLEND);//*
        
		self.filename = inFilename;
		//glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST); 
		glGenTextures(1, &texture[0]);
		glBindTexture(GL_TEXTURE_2D, texture[0]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 		
  
		NSString *path = inFilename;//[[NSBundle mainBundle] pathForResource:baseFilename ofType:extension];
		CGDataProviderRef file =  CGDataProviderCreateWithFilename([path UTF8String]);
        if (file == nil)
            return nil;
		CGImageRef image = CGImageCreateWithJPEGDataProvider(file, NULL, YES, kCGRenderingIntentDefault);

        GLuint width = (GLuint) CGImageGetWidth(image);
        GLuint height = (GLuint) CGImageGetHeight(image);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        void *imageData = malloc( height * width * 4 );
        CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaNoneSkipLast   ); //kCGImageAlphaPremultipliedLast| kCGBitmapByteOrder32Big
        CGContextTranslateCTM (context, 0, height);
        CGContextScaleCTM (context, 1.0, -1.0);
        CGColorSpaceRelease( colorSpace );
        CGContextClearRect( context, CGRectMake( 0, 0, width, height ));
        CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image );
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
        CGContextRelease(context);
        free(imageData);
		CGImageRelease(image);
 	}
	return self;
}
+ (void)useDefaultTexture
{
	glBindTexture(GL_TEXTURE_2D, 0);
}
- (void)use
{
	glBindTexture(GL_TEXTURE_2D, texture[0]);
}
- (void)dealloc
{
	//NSLog(@"dealloc texture");
	glDeleteTextures(1, &texture[0]);
	filename = nil;
	[super dealloc];
}

@end
