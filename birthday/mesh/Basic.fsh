//
//  Shader.fsh
//  gltestwithshaderfiles
//
//  Created by Chris Allen on 25/06/2013.
//  Copyright (c) 2013 Chris Allen. All rights reserved.
//

varying lowp vec4 colorVarying;
uniform sampler2D _MainTex;
void main()
{
    gl_FragColor = colorVarying;//gl_FragColor = vec4( 0.0,1.0,0.5, 1.0 );
}
