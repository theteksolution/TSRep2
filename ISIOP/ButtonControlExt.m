//
//  ButtonControlExt.m
//  TestTabController1
//
//  Created by LRich on 12/29/12.
//  Copyright (c) 2012 LR
//

#import "ButtonControlExt.h"
#import <QuartzCore/QuartzCore.h>
@implementation ButtonControlExt

@synthesize bRow;
@synthesize bSection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
         }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/ 
- (void)drawRect:(CGRect)rect
{
    [[self layer] setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0f];
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:1.0];
}


@end
