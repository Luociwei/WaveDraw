//
//  ViewController.m
//  draw
//
//  Created by IvanGan on 15/7/2.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


@synthesize wnd = _wnd;
@synthesize cd = _cd;
@synthesize btnLabel;
@synthesize btnX;
@synthesize btnY;
@synthesize btnDetail;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark -
#pragma mark Action
-(IBAction)btnLoad:(id)sender
{
    NSOpenPanel * op = [NSOpenPanel openPanel];
    NSArray *fileTypes = [NSArray arrayWithObjects: @"txt",nil];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:fileTypes];
    
    [op beginSheetModalForWindow:_wnd completionHandler:^(NSInteger result){
        if(result == NSFileHandlingPanelOKButton){
            if(op.URLs.count == 1){
                NSURL * url = [op.URLs objectAtIndex:0];
                [_cd loadData:url.path];
                [btnDetail setEnabled:YES];
            }
        }
    }];
}

-(IBAction)btnShowLabel:(id)sender
{
    if([[btnLabel title]isEqualToString:@"ShowLabel"])
    {
        [btnLabel setTitle:@"HideLabel"];
        _cd.labelEnable = TRUE;
    }
    else
    {
        [btnLabel setTitle:@"ShowLabel"];
        _cd.labelEnable = FALSE;
    }
    [_cd setNeedsDisplay:YES];
}

-(IBAction)btnShowXGride:(id)sender
{
    if([[btnX title] isEqualTo:@"ShowX"])
    {
        [btnX setTitle:@"HideX"];
        _cd.xGrideEnable = TRUE;
    }
    else
    {
        [btnX setTitle:@"ShowX"];
        _cd.xGrideEnable = FALSE;
    }
    [_cd setNeedsDisplay:YES];
}

-(IBAction)btnShowYGride:(id)sender
{
    if([[btnY title] isEqualTo:@"ShowY"])
    {
        [btnY setTitle:@"HideY"];
        _cd.yGrideEnable = TRUE;
    }
    else
    {
        [btnY setTitle:@"ShowY"];
        _cd.yGrideEnable = FALSE;
    }
    [_cd setNeedsDisplay:YES];
}

-(IBAction)btnSavePic:(id)sender
{
    NSSavePanel *saveDlg = [[NSSavePanel alloc]init];
    saveDlg.title = @"Save File";
    saveDlg.message = @"Save File";
    saveDlg.allowedFileTypes = @[@"png"];
    saveDlg.nameFieldStringValue = @"wave_pic_xx";
    [saveDlg beginWithCompletionHandler: ^(NSInteger result){
        
        if(result==NSFileHandlingPanelOKButton){
            
            [_cd saveImage:[[saveDlg URL] path]];
        }
        
    }];

}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationController] class] == [MyView class])
    {
        MyView * myview = [segue destinationController];
        [myview setTitle:@"DetailInfo"];
        myview.timeStamp = _cd.timeArr;
        myview.data = _cd.data;
    }
}



@end
