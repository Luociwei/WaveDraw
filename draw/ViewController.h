//
//  ViewController.h
//  draw
//
//  Created by IvanGan on 15/7/2.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CocoaDrawing.h"
#import "MyView.h"

@interface ViewController : NSViewController
{
//    MyView * myview;
}

@property(assign)IBOutlet NSWindow * wnd;
@property(assign)IBOutlet CocoaDrawing * cd;
@property(assign)IBOutlet NSButton * btnLabel;
@property(assign)IBOutlet NSButton * btnX;
@property(assign)IBOutlet NSButton * btnY;
@property(assign)IBOutlet NSButton * btnDetail;

-(IBAction)btnLoad:(id)sender;
-(IBAction)btnShowLabel:(id)sender;
-(IBAction)btnShowXGride:(id)sender;
-(IBAction)btnShowYGride:(id)sender;

@end

