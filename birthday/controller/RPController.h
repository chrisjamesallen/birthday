#import <Foundation/Foundation.h>
#import "RPGLView.h"

@interface RPController : NSObject
{

	 RPGLView  *view;
	 NSMutableArray  *shaders;

}

- (void) start;
- (void) render;
@property (nonatomic,retain)  RPGLView  *view;
@property (nonatomic,retain)  NSMutableArray  *shaders;
@end