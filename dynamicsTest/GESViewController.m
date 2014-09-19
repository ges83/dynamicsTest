//
//  GESViewController.m
//  dynamicsTest
//
//  Created by Gustavo on 09/04/14.
//  Copyright (c) 2014 Not. All rights reserved.
//

#import "GESViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface GESViewController ()
{
    CGRect rectViewObjectStart;
    CGRect rectGreenViewObjStart;
    BOOL isActiveBehaviors;
    NSMutableArray *views;
	CMMotionManager *motionManager;
	NSTimer *timer;
	float rotation;
    CMAttitude *referenceAttitude;
    GLfloat rotMatrix[16];
}

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@end

@implementation GESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

    views = [[NSMutableArray alloc]init];
    
    rectViewObjectStart = self.viewObject.frame;
    rectGreenViewObjStart = self.viewGreenObject.frame;
    
    for (UIView *currentView in [self.view subviews]) {
        if (![currentView conformsToProtocol:@protocol(UILayoutSupport)] && ![currentView isKindOfClass:[UIButton class]]){
            [views addObject: currentView];
        }
    }
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]initWithItems:views];
    [self.gravity setMagnitude:5.0f];
    self.collision = [[UICollisionBehavior alloc]initWithItems:views];
    [self.collision setTranslatesReferenceBoundsIntoBoundary:YES];
    
    [self change_grav_pressed:nil];
    
}
- (IBAction)grav_pressed:(id)sender {
    [self addBehaviors];
    [self.gravity setGravityDirection:CGVectorMake(0, -1.0)];
}

- (IBAction)grav_left_pressed:(id)sender{
    [self addBehaviors];
    [self.gravity setGravityDirection:CGVectorMake(-1.0, 0)];
}

- (IBAction)grav_right_pressed:(id)sender{
    [self addBehaviors];
    [self.gravity setGravityDirection:CGVectorMake(1.0, 0)];
}

- (IBAction)reset_pressed:(id)sender {
    [self addBehaviors];
    [self resetPositions];
}

- (IBAction)change_grav_pressed:(id)sender {
    [self addBehaviors];
    [self.gravity setGravityDirection:CGVectorMake(0, 1.0)];
}

- (IBAction)damping_pressed:(id)sender{
    
    //__weak UIViewContro *weakSelf = self;
    
    if ( [[UIView class] respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]){
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:25.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect pos = CGRectMake([self posInBounds:self.viewGreenObject.frame.origin.x], self.viewGreenObject.frame.origin.y, self.viewGreenObject.frame.size.width, self.viewGreenObject.frame.size.height);
            [self.viewGreenObject setFrame:pos];
        } completion:nil];
    } else {
        [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect pos = CGRectMake([self posInBounds:self.viewGreenObject.frame.origin.x], self.viewGreenObject.frame.origin.y, self.viewGreenObject.frame.size.width, self.viewGreenObject.frame.size.height);
            [self.viewGreenObject setFrame:pos];
        } completion:nil];
    }
    
}

-(CGFloat)posInBounds:(CGFloat)currentPos
{
    if (currentPos < self.view.frame.size.width) {
        currentPos += 200;
    } else {
        currentPos -= 200;
    }
    
    return currentPos;
}

-(void)addBehaviors
{
    if (!isActiveBehaviors) {
        [self.animator addBehavior:self.gravity];
        [self.animator addBehavior:self.collision];
        
        isActiveBehaviors = YES;
    }
}

-(void)resetPositions
{
    [self.viewObject setFrame:rectViewObjectStart];
    [self.viewGreenObject setFrame:rectGreenViewObjStart];
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDevice *device = (UIDevice*)notification.object;
    
    switch (device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self grav_left_pressed:nil];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self grav_right_pressed:nil];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self change_grav_pressed:nil];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self grav_pressed:nil];
            break;
        default:
            break;
    }
}

@end
