//
//  MyView.h
//  draw
//
//  Created by IvanGan on 15/7/6.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicDraw.h"
@interface MyView : NSViewController
{
//    IBOutlet BasicDraw * bdView;
    IBOutlet NSComboBox * cmb;
    IBOutlet NSButton * btnSave;
}

@property(assign)IBOutlet NSWindow * wnd;
@property(retain) NSArray * data;
@property(retain) NSArray * timeStamp;
@property(assign) IBOutlet BasicDraw * bdView;

-(IBAction)btnSave:(id)sender;

@end
