//
//  MyView.m
//  draw
//
//  Created by IvanGan on 15/7/6.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import "MyView.h"
#import "math.h"

@interface MyView ()

@end

@implementation MyView

@synthesize data;
@synthesize timeStamp;
@synthesize bdView;

@synthesize wnd = _wnd;

#define EMPTY_STR @"NULL"
#define GAP_OF_SIDE 5//Canvas in View Rect
//X_ORIGION is the distance from x_Start.x to x.origion
//Y_ORIGION is the distance from y_Start.x to y.origion
#define X_ORIGION 10//begin origon, origion will changed by the data. Normally, use "self.origion"
#define Y_ORIGION 10//begin origon, origion will changed by the data. Normally, use "self.origion"

#define X_LABEL_GAP 100.0//
#define Y_LABEL_GAP 100.0
#define X_LABEL_WIDTH 120.0
#define Y_LABEL_WIDTH 20.0

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comboSelectChanged) name:NSComboBoxSelectionIsChangingNotification object:nil];//notification will crash :-(...
    // Do view setup here.
    if([timeStamp count]>0)
    {
        [cmb removeAllItems];
        [cmb addItemsWithObjectValues:timeStamp];
    }
}

-(NSArray *)sortDataByAscending:(NSArray*)arr
{
    NSComparator cmp = ^(id obj1, id obj2){
        if([obj1 floatValue] > [obj2 floatValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else return (NSComparisonResult)NSOrderedAscending;
    };
    return [arr sortedArrayUsingComparator:cmp];
}

-(IBAction)btnShow:(id)sender
{
    [self comboSelectChanged];
}

-(void)comboSelectChanged
{
    bdView.baseInfo = [cmb stringValue];
    NSInteger index = [cmb indexOfSelectedItem];
    bdView.baseInfo = [cmb itemObjectValueAtIndex:index];
    if(index < [data count])
    {
        NSArray * tmp = [data objectAtIndex:index];
        if([tmp count]>0)
        {
            NSArray * arr = [self sortDataByAscending:tmp];
            bdView.minValue = floor([[arr firstObject]floatValue]);
            bdView.maxValue = ceil([[arr objectAtIndex:[arr count]-1]floatValue]);
            bdView.gapOfSide = GAP_OF_SIDE;
            bdView.xOrigion = X_ORIGION;
            bdView.yOrigion = Y_ORIGION;
        
            bdView.xLabelGap = X_LABEL_GAP;
            bdView.yLabelGap = Y_LABEL_GAP;
            bdView.xLabelWidth = X_LABEL_WIDTH;
            bdView.yLabelWidth = Y_LABEL_WIDTH;
        
            bdView.origin = NSMakePoint(X_ORIGION,Y_ORIGION);
        
            bdView.data = tmp;
            bdView.xGrideEnable = TRUE;
            bdView.yGrideEnable = TRUE;
            
            NSMutableArray * tm = [[NSMutableArray alloc]init];
            for (int i=0; i<[arr count]; i++) {
                [tm addObject:[NSString stringWithFormat: @"%d",i ]];
            }
            bdView.xData = tm;
            [tm release];
        }
    }
    [bdView setNeedsDisplay:YES];
}

-(IBAction)btnSave:(id)sender
{
    NSOpenPanel * op = [NSOpenPanel openPanel];
    NSArray *fileTypes = [NSArray arrayWithObjects: @"png",@"jpeg",@"jpg",@"gif",@"bmp",nil];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:fileTypes];
    
    [op beginSheetModalForWindow:_wnd completionHandler:^(NSInteger result){
        if(result == NSFileHandlingPanelOKButton){
            if(op.URLs.count == 1){
                NSURL * url = [op.URLs objectAtIndex:0];
                [bdView saveImage:url.path];
            }
        }
    }];
}

-(void)rightMouseDown:(NSEvent *)theEvent
{

}

-(void)dealloc
{
//    if(data) [data release];
//    if(timeStamp) [timeStamp release];
//    if(bdView) [bdView release];
    [super dealloc];
}

@end
