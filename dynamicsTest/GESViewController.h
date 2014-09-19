;//
//  GESViewController.h
//  dynamicsTest
//
//  Created by Gustavo on 09/04/14.
//  Copyright (c) 2014 Not. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GESViewController : UIViewController <UIDynamicAnimatorDelegate,UIAccelerometerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewObject;
@property (weak, nonatomic) IBOutlet UIView *viewGreenObject;

@end
