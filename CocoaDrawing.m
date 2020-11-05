//
//  CocoaDrawing.m
//  draw
//
//  Created by IvanGan on 15/7/2.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import "CocoaDrawing.h"
#import "math.h"
#import "PythonTask.h"

@implementation CocoaDrawing

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

@synthesize drawInfo;
@synthesize data;
@synthesize timeArr;

-(id)init
{
    self = [super init];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    [self drawRoundRect:[self waveRect] fillColor:[NSColor whiteColor] strokeColor:[NSColor whiteColor] radius:3.0 lineWidht:1.0];
    [self draw_X_Y:[self waveRect] lineColor:[NSColor blueColor] lineWidht:1.0 XName:@"X" YName:@"Y"];
    
    if(drawInfo)
        [self drawText:drawInfo inRect:NSMakeRect(x_Axis.len/2-30, y_Axis.end.y-20, 200, 10) color:[NSColor blackColor]];

    if([self.datas count]>0)
    {
//        [self drawText:@"MaxValue" inRect:NSMakeRect(GAP_OF_SIDE+X_ORIGION+30, self.bounds.size.height-GAP_OF_SIDE-30, 70, 10) color:[NSColor redColor]];//Write the top of Y-Axis
//        [self drawText:@"MiddleValue" inRect:NSMakeRect(GAP_OF_SIDE+X_ORIGION+30, self.bounds.size.height-GAP_OF_SIDE-40, 70, 10) color:[NSColor greenColor]];//Write the top of Y-Axis
//        [self drawText:@"MinValue" inRect:NSMakeRect(GAP_OF_SIDE+X_ORIGION+30, self.bounds.size.height-GAP_OF_SIDE-50, 70, 10) color:[NSColor brownColor]];//Write the top of Y-Axis
        
        [self drawWaveForm:self.datas lineColor:[NSColor redColor] lineWidth:1.0];
//        [self drawWaveForm:minData lineColor:[NSColor brownColor] lineWidth:1.0];
//        [self drawWaveForm:midData lineColor:[NSColor greenColor] lineWidth:1.0];
        
//        [self draw_X_Grid:[self waveRect] Label:timeArr txtColor:[NSColor blueColor] lineColor:[NSColor lightGrayColor] lineWidht:0.5];
        [self draw_Y_Grid:[self waveRect] txtColor:[NSColor blueColor] lineColor:[NSColor lightGrayColor] lineWidht:0.5];
    }
}

#pragma mark -
#pragma mark Action
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
-(NSString *)cw_getString:(NSString *)string from:(NSString *)from and:(NSString *)to
{
    NSString *mutString = @"";
    if([string containsString:from]&&[string containsString:to])
    {
        
        NSRange range1 = [string rangeOfString:from];
        NSRange range2 = [string rangeOfString:to];
        
        NSInteger tempLength =range2.location-range1.location-range1.length;
        NSRange range = {range1.location+range1.length,tempLength};
        mutString = [string substringWithRange:range];
        
    }
    return mutString;
}


-(void)loadData:(NSString* )file
{
    [self initVariant];
    if(drawInfo) [drawInfo setString:@""];
    [drawInfo appendString:[file lastPathComponent]];
    
    NSString *budle_path = [[NSBundle mainBundle] resourcePath];
    NSString *python_file1 = [budle_path stringByAppendingPathComponent:@"python_test/replace_5-22.py"];
    NSString *python_file = [[NSBundle mainBundle] pathForResource:@"replace_05-22.py" ofType:nil];
    NSString *lauchPath = [budle_path stringByAppendingPathComponent:@"python_test/venv/bin/python3"];;
    PythonTask *pTask = [[PythonTask alloc]initWithPythonPath:python_file1 parArr:@[file] lauchPath:lauchPath];
    
    NSString *mut_dataStr = [pTask read];
    NSString *dataStr = [self cw_getString:mut_dataStr from:@"new_7_start:" and:@"new_7_end"];
    if (!dataStr.length) {
        return;
    }
     //print("new_7_start:"+new_str+"new_7_end")
    //NSString * dataStr = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if([dataStr length]==0) return;
    NSString * sep;

    if([dataStr containsString:@","])
        sep = @",";
    else if([dataStr containsString:@"\r\n"])
        sep = @"\r\n";
    else if ([dataStr containsString:@"\n"])
        sep = @"\n";
    else if([dataStr containsString:@"\r"])
        sep = @"\r";
    else
        [drawInfo appendString:@"<File Format Error>"];
    if(sep){
        NSArray * tmp = [dataStr componentsSeparatedByString:sep];
        [self.datas addObjectsFromArray:tmp];
        [self.datas removeLastObject];

    }

    self.maxValue = ceil([[[self sortDataByAscending:self.datas]objectAtIndex:[self.datas count]-1]floatValue]);
    self.minValue = floor([[[self sortDataByAscending:self.datas]objectAtIndex:0]floatValue]);
    
    self.gapOfSide = GAP_OF_SIDE;
    self.xOrigion = X_ORIGION;
    self.yOrigion = Y_ORIGION;
    
    self.xLabelGap = X_LABEL_GAP;
    self.yLabelGap = Y_LABEL_GAP;
    self.xLabelWidth = X_LABEL_WIDTH;
    self.yLabelWidth = Y_LABEL_WIDTH;
    
    self.origin = NSMakePoint(X_ORIGION,Y_ORIGION);
    
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Init & dealloc

-(void)initVariant
{
    if(self.datas)
        [self.datas removeAllObjects];
    else
        self.datas = [[NSMutableArray alloc]init];

    if(maxData)
        [maxData removeAllObjects];
    else
        maxData = [[NSMutableArray alloc]init];
    if(minData)
        [minData removeAllObjects];
    else
        minData = [[NSMutableArray alloc]init];
    if(midData)
        [midData removeAllObjects];
    else
        midData = [[NSMutableArray alloc]init];
    if(timeArr)
        [timeArr removeAllObjects];
    else
        timeArr = [[NSMutableArray alloc]init];
    if(drawInfo)
       [drawInfo setString:@""];
    else
        drawInfo = [[NSMutableString alloc]init];
}

-(void)dealloc
{
    if(self.datas)
    {
        [self.datas removeAllObjects];
        [self.datas release];
    }
    if(maxData)
    {
        [maxData removeAllObjects];
        [maxData release];
    }
    if(minData)
    {
        [minData removeAllObjects];
        [minData release];
    }
    if(midData)
    {
        [minData removeAllObjects];
        [midData release];
    }
    if(timeArr)
    {
        [timeArr removeAllObjects];
        [timeArr release];
    }
    if(drawInfo)
       [drawInfo release];

    [super dealloc];
}

@end
