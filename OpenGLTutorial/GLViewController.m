//
//  GLViewController.m
//  OpenGLTutorial
//
//  Created by Eric Lanz on 12/28/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "GLViewController.h"
#import "ShaderController.h"
#import "Vertex.h"
#import "ESDrawable.h"

const Vertex QuadVertices[] = {
    {{1, -1, 1}, {1, 0}},
    {{1, 1, 1}, {1, 1}},
    {{-1, 1, 1}, {0, 1}},
    {{1, 1, 1}, {1, 1}},
    {{-1, -1, 1}, {0, 0}},
    {{1, -1, 1}, {1, 0}}
};

@interface GLViewController ()

@end

@implementation GLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context)
        NSLog(@"Failed to create ES context");
    
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    view.drawableMultisample = GLKViewDrawableMultisampleNone;
    self.preferredFramesPerSecond = 30;
    
    _shaders = [[ShaderController alloc] init];
    [_shaders loadShaders];
    
    glGenBuffers(1, &_lineBuffer);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glEnableVertexAttribArray(ATTRIB_TEX01);
    
    glLineWidth(10.0);
    
    _drawables = [NSMutableArray array];
    
    for (int i = 0; i < 50; i++)
    {
        float x = (((float) rand() / RAND_MAX) * 10) - 5;
        float y = (((float) rand() / RAND_MAX) * 10) - 5;
        int scale = arc4random()%30 + 1;
        GLKVector4 color = GLKVector4Make(arc4random() % 256 / 256.0, arc4random() % 256 / 256.0, arc4random() % 256 / 256.0, 1.0);
        ESDrawable * drawable = [[ESDrawable alloc] initWithShader:_shaders.lineShader
                                                             color:color
                                                          position:GLKVector3Make(x, y, 0.0)];
        [drawable setScale:GLKVector3Make(scale, scale, 1)];
        [_drawables addObject:drawable];
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, _lineBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(QuadVertices), QuadVertices,  GL_STATIC_DRAW);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [_drawables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(ESDrawable*)obj drawWithView:_viewMatrix];
    }];

#ifdef DEBUG
    static int framecount = 0;
    framecount ++;
    if (framecount > 30)
    {
        float ft = self.timeSinceLastDraw;
        NSString * debugText = [NSString stringWithFormat:@"%2.1f, %0.3f", 1.0/ft, ft];
        [self.debugLabel setText:debugText];
        framecount = 0;
    }
#endif
}

- (void)update
{
    float aspect = fabsf([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
    _viewMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0f), aspect, 1.0, 100.0);
    static float angle = 0.0;
    angle += 1.0;
    if (angle > 360.0) angle = 0.0;
    [_drawables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ESDrawable * drawable = obj;
        [drawable setRotation:GLKVector3Make(0.0, 0.0, angle)];
        [drawable updateWithDeltaTime:self.timeSinceLastUpdate];
    }];
}

@end
