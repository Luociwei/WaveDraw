//
//  CocoaDrawing.h
//  draw
//
//  Created by IvanGan on 15/7/2.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicDraw.h"

@interface CocoaDrawing : BasicDraw
{
    long dataLen;
//    int maxValue;
//    int minValue;
    NSPoint origin;
    
    NSMutableArray * maxData;//max data
    NSMutableArray * minData;//min data
    NSMutableArray * midData;//middle data
    
//    NSMutableArray * xAxisLocation;//x Axis location. For mark time stamp
//    struct Axis_Line x_Axis;
//    struct Axis_Line y_Axis;
}

@property(retain)NSMutableArray * datas;//All datasortData
@property(retain)NSMutableArray * timeArr;//time stamp
@property(copy)NSMutableString * drawInfo;
-(void)loadData:(NSString* )file;


@end
