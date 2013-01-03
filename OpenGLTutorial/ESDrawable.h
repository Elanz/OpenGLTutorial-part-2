//
//  ESDrawable.h
//  OpenGLTutorial2
//
//  Created by Eric Lanz on 1/3/13.
//  Copyright (c) 2013 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import <GLKit/GLKit.h>

@interface ESDrawable : NSObject
{
    GLKMatrix4 _model;
    BOOL _dirty;
}

@property (nonatomic, readwrite) GLKVector3 position;
@property (nonatomic, readwrite) GLKVector3 rotation;
@property (nonatomic, readwrite) GLKVector3 scale;
@property (nonatomic, readwrite) GLuint shader;
@property (nonatomic, readwrite) GLKVector4 color;

- (id) initWithShader:(GLuint)shader color:(GLKVector4)color position:(GLKVector3)position;
- (void) drawWithView:(GLKMatrix4)viewMatrix;
- (void) updateWithDeltaTime:(NSTimeInterval)dTime;

@end
