//
//  BasicDraw.m
//  draw
//
//  Created by IvanGan on 15/7/6.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import "BasicDraw.h"

@implementation BasicDraw

@synthesize maxValue;
@synthesize minValue;
@synthesize data;
@synthesize xData;
@synthesize gapOfSide;
@synthesize xOrigion;
@synthesize yOrigion;

@synthesize xLabelGap;
@synthesize yLabelGap;
@synthesize xLabelWidth;
@synthesize yLabelWidth;

@synthesize baseInfo;
@synthesize origin;

@synthesize xGrideEnable;
@synthesize yGrideEnable;
@synthesize labelEnable;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
//    
//    [self drawRoundRect:dirtyRect fillColor:[NSColor whiteColor] strokeColor:[NSColor whiteColor] radius:3.0 lineWidht:1.0];
//    [self draw_X_Y:[self waveRect] lineColor:[NSColor blueColor] lineWidht:1.0 XName:@"time" YName:@"Value"];
//    if([baseInfo length]>0)
//        [self drawText:baseInfo inRect:NSMakeRect(x_Axis.len/2-30, y_Axis.end.y-20, 150, 10) color:[NSColor blackColor]];
//    
//    if(data)
//    {
//        [self drawWaveForm:data lineColor:[NSColor greenColor] lineWidth:1.0];
//        [self draw_X_Grid:[self waveRect] Label:xData txtColor:[NSColor blueColor] lineColor:[NSColor lightGrayColor] lineWidht:0.5];
//        [self draw_Y_Grid:[self waveRect] txtColor:[NSColor blueColor] lineColor:[NSColor lightGrayColor] lineWidht:0.5];
//    }
}

#pragma mark -
#pragma mark WaveForm Drawing

-(int)calXPosition:(long)cnt Index:(long)index
{
    return index/cnt * (x_Axis.end.x - x_Axis.origion) + x_Axis.origion;
}

-(NSPoint)dataToPoint:(float)value Count:(long)cnt Index:(float)index//need to conver long to float.
{
    int x = index/cnt * (x_Axis.end.x - x_Axis.origion) + x_Axis.origion;
    int y = (float)(value - minValue)/(float)(maxValue - minValue) * y_Axis.len + y_Axis.disCal;//y_Axis.start.y;
    [xAxisLocation addObject:[NSNumber numberWithInt:x]];
    return NSMakePoint(x, y);
}

-(void)drawWaveForm:(NSArray*)array lineColor:(NSColor*)color lineWidth:(CGFloat)lineWidth//float array
{
    NSBezierPath * bp = [NSBezierPath bezierPath];
    [color set];
    bp.lineWidth = lineWidth;
    long cnt = [array count];
    if(xAxisLocation)
        [xAxisLocation removeAllObjects];
    else
        xAxisLocation = [[NSMutableArray alloc]init];
    for (long i=0; i<cnt; i++) {
        NSPoint pt = [self dataToPoint:[[array objectAtIndex:i]floatValue] Count:cnt Index:i];
        if(labelEnable == TRUE)//draw value
            [self drawText:[array objectAtIndex:i] inRect:NSMakeRect(pt.x, pt.y, 20, 10) color:color];
        if(i==0)
            [bp moveToPoint:pt];
        else
            [bp lineToPoint:pt];
    }
    [bp stroke];
    [self drawText:[NSString stringWithFormat:@"%d",maxValue] inRect:NSMakeRect(x_Axis.origion, y_Axis.end.y-gapOfSide-17, 30, 10) color:[NSColor blueColor]];
    [self drawText:[NSString stringWithFormat:@"%d",minValue] inRect:NSMakeRect(x_Axis.origion, y_Axis.start.y, 30, 10) color:[NSColor blueColor]];
}


#pragma Mark -
#pragma Mark Action

-(void)saveImage:(NSString*)filePath{
    NSView *view = self.window.contentView;
    NSRect r = [view frame];
    NSData* dataq = [view dataWithPDFInsideRect:r];
    NSPDFImageRep *img = [NSPDFImageRep imageRepWithData:dataq];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSInteger count = [img pageCount];
    
    for(NSInteger i = 0 ; i < count ; i++) {
//        NSString *filePath = [NSString stringWithFormat:@"/Users/ciweiluo/Desktop/file%ld.png",i];
        [img setCurrentPage:i];
        NSImage *temp = [[NSImage alloc] init];
        [temp addRepresentation:img];
        NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[temp TIFFRepresentation]];
        NSData *finalData = [rep representationUsingType:NSPNGFileType properties:nil];
        [fileManager createFileAtPath:filePath contents:finalData attributes:nil];
    }
}
//-(void)saveImage:(NSString*)file
//{
//    NSBitmapImageRep *rep;
//
//    [self lockFocus];
//    rep = [[NSBitmapImageRep alloc]initWithFocusedViewRect:self.bounds];
//    [self unlockFocus];
//
//    NSBitmapImageFileType tp = NSPNGFileType;
//    NSString * exten = [[file pathExtension] lowercaseString];
//    if([exten isEqualTo:@"bmp"])
//        tp = NSBMPFileType;
//    else if([exten isEqualTo:@"jpeg"] || [exten isEqualTo:@"jpg"])
//        tp = NSJPEGFileType;
//    else if([exten isEqualTo:@"gif"])
//        tp = NSGIFFileType;
//
//    [[rep representationUsingType:tp properties:nil] writeToFile:file atomically:YES];
//
//    //        [[self dataWithPDFInsideRect:self.bounds]writeToFile:@"/Users/ivangan/Desktop/map.pdf" atomically:YES];
//    [rep release];
//}

#pragma mark -
#pragma mark X-Y Drawing

-(void)draw_X_Y:(NSRect)bounds lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth XName:(NSString*)XN YName:(NSString*)YN
{
    int x_end = bounds.size.width - gapOfSide;
    int y_end = bounds.size.height - gapOfSide;
    
    NSString * oriStr;
    int x_pos = 0;
    if ( abs(minValue)>0) {
        x_pos=(int)(maxValue-minValue)/abs(minValue);//only X-Axis move up or down.
    }
    
    int y_pos = xOrigion + gapOfSide;//y_Axis position
    y_Axis.origionValue = 0;
    oriStr = [NSString stringWithFormat:@"%d",y_Axis.origionValue];
    
    x_Axis.start = NSMakePoint(gapOfSide, x_pos);
    x_Axis.end = NSMakePoint(x_end, x_pos);
    x_Axis.len = x_end - gapOfSide;//tow side has a gap
    
    y_Axis.origion = x_pos;
    y_Axis.start = NSMakePoint(y_pos, gapOfSide);
    y_Axis.end = NSMakePoint(y_pos, y_end);
    y_Axis.len = y_end - gapOfSide - yOrigion;
    y_Axis.disCal = gapOfSide + yOrigion;

    x_Axis.origion = y_pos;
    origin = NSMakePoint(y_pos, x_pos);
    
    
    [lineColor set];
    NSBezierPath * path = [NSBezierPath bezierPath];
    path.lineWidth = lineWidth;
    
    [path moveToPoint:NSMakePoint(gapOfSide, x_pos)];
    [path lineToPoint:NSMakePoint(x_end, x_pos)];
    [path stroke];//x-Axis
    
    [path moveToPoint:NSMakePoint(y_pos, gapOfSide)];
    [path lineToPoint:NSMakePoint(y_pos, y_end)];
    [path stroke];//y-axis
    
    
    [self drawText:XN inRect:NSMakeRect(bounds.size.width-25, ((x_pos-10>=0)?(x_pos-10):(x_pos+2)), 30, 10) color:lineColor];//write to the end of X-Axis
    [self drawText:YN inRect:NSMakeRect(((y_pos-25>=0)?(y_pos-25):(y_pos+5)), bounds.size.height-gapOfSide-10, 30, 10) color:lineColor];//Write the top of Y-Axis
    [self drawText:oriStr inRect:NSMakeRect(((y_pos-10>=0)?(y_pos-10):(y_pos+2)), x_pos, 30, 10) color:lineColor];//X-Axis up or down.
}

-(void)draw_X_Grid:(NSRect)bounds Label:(NSMutableArray*)lbl txtColor:(NSColor*)txtColor lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth//||||
{
    if(xGrideEnable != TRUE) return;
    int x_end = x_Axis.end.x;
    
    int cnt = (x_end - x_Axis.origion)/xLabelGap;//how many label can be drawed.
    long gap = ceil([lbl count]*1.0/cnt);
    
    NSBezierPath * bp = [NSBezierPath bezierPath];
    [lineColor set];
    bp.lineWidth = lineWidth;
    CGFloat arr[10] = {2,4,4,4};
    [bp setLineDash:arr count:4 phase:0];
    
    for (long i=0; i<[lbl count]; i=i+gap) {
        NSString * timeStr = [lbl objectAtIndex:i];//1970-01-01 08:17:36:596
        if([timeStr length]>20)
        {
            timeStr = [timeStr substringFromIndex:11];//08:17:36:596
        }
        NSInteger x_pos = [[xAxisLocation objectAtIndex:i]integerValue];
        if([timeStr isNotEqualTo:@"NULL"])
        {
            NSRect rct = NSMakeRect(x_pos, x_Axis.start.y-10, xLabelWidth, 10);
            [self drawText:timeStr inRect:rct color:txtColor];
        }
        if (i==0) continue;//the first line is Y_Axis
        [bp moveToPoint:NSMakePoint(x_pos, y_Axis.start.y)];
        [bp lineToPoint:NSMakePoint(x_pos, y_Axis.end.y)];
    }
    [bp stroke];
    [xAxisLocation removeAllObjects];
}

-(void)drawYLowerPart:(NSBezierPath*)bp :(int)uValue :(int)lValue :(NSColor*)txtColor
{
    float cnt = (float)(y_Axis.origion - y_Axis.start.y)/yLabelGap;
    if (cnt<=1)return;
    float gap = (uValue-lValue)*1.0/cnt;
    //    NSLog(@"cnt:%d,lowergap:%.1f",cnt,gap);
    for (int i= 1; i<ceil(cnt); i++) {
        int y = y_Axis.origion - i * yLabelGap;
        [bp moveToPoint:NSMakePoint(x_Axis.start.x, y)];
        [bp lineToPoint:NSMakePoint(x_Axis.end.x, y)];
        [self drawText:[NSString stringWithFormat:@"%.1f",uValue-i*gap] inRect:NSMakeRect(x_Axis.start.x, y, yLabelWidth, 10) color:txtColor];
    }
}

-(void)drawYUpperPart:(NSBezierPath*)bp :(int)uValue :(int)lValue :(NSColor*)txtColor
{
    float cnt = (float)(y_Axis.end.y - y_Axis.origion)/yLabelGap;
    if(cnt==0) return;
    float gap = (uValue-lValue)*1.0/(float)cnt;
    //    NSLog(@"cnt:%d,uppergap:%.f",cnt,gap);
    for (int i= 1; i<ceil(cnt); i++) {
        int y = y_Axis.origion + i * yLabelGap;
        [bp moveToPoint:NSMakePoint(x_Axis.start.x, y)];
        [bp lineToPoint:NSMakePoint(x_Axis.end.x, y)];
        [self drawText:[NSString stringWithFormat:@"%.1f",lValue+i*gap] inRect:NSMakeRect(x_Axis.start.x, y, yLabelWidth, 10) color:txtColor];
    }
}

-(void)draw_Y_Grid:(NSRect)bounds txtColor:(NSColor*)txtColor lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth//----
{
    if(yGrideEnable != TRUE) return;
    
    NSBezierPath * bp = [NSBezierPath bezierPath];
    [lineColor set];
    bp.lineWidth = lineWidth;
    CGFloat arr[10] = {2,4,4,4};
    [bp setLineDash:arr count:4 phase:0];
    
    if(y_Axis.origionValue == maxValue)
    {
        [self drawYLowerPart:bp :maxValue :minValue :txtColor];
    }
    else if (y_Axis.origionValue == minValue)
    {
        [self drawYUpperPart:bp :maxValue :minValue :txtColor];
    }
    else
    {
        [self drawYLowerPart:bp :y_Axis.origionValue :minValue :txtColor];
        [self drawYUpperPart:bp :maxValue :y_Axis.origionValue :txtColor];
    }
    [bp stroke];
}

#pragma mark -
#pragma mark Rect Drawing
- (NSRect) waveRect
{
    NSRect r = NSMakeRect(0, 0, self.bounds.size.width - 0*2, self.bounds.size.height - 0*2);
    return r;
}

- (void) drawRoundRect:(NSRect)bounds fillColor:(NSColor *)fillColor strokeColor:(NSColor *)strokeColor radius:(CGFloat)radius lineWidht:(CGFloat)lineWidth
{
    CGRect frame = NSMakeRect(bounds.origin.x+(lineWidth/2), bounds.origin.y+(lineWidth/2), bounds.size.width - lineWidth, bounds.size.height - lineWidth);
    
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:radius yRadius:radius];
    
    path.lineWidth = lineWidth;
    path.flatness = 0.0;
    
    [fillColor setFill];
    [path fill];
    
    [strokeColor set];
    [path stroke];
    
}


#pragma mark -
#pragma mark Text Drawing
- (void) drawTextCentered:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color
{
    if(text == nil) return;
    [[NSGraphicsContext currentContext] saveGraphicsState];
    NSFont *fnt = [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
    
    NSRectClip(rect);
    NSPoint pt = NSMakePoint(rect.origin.x, rect.origin.y + ((rect.size.height/2)-(fnt.xHeight/2)) + fnt.descender);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,fnt,NSFontAttributeName,color,NSForegroundColorAttributeName, nil];
    NSSize s = [text sizeWithAttributes:attr];
    pt.x = rect.origin.x + (rect.size.width / 2) - (s.width/2);
    
    [text drawAtPoint:pt withAttributes:attr];
    [style release];
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (void) drawTextRight:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color
{
    if(text == nil) return;
    [[NSGraphicsContext currentContext] saveGraphicsState];
    NSRectClip(rect);
    
    NSFont *fnt = [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
    
    NSPoint pt = NSMakePoint(rect.origin.x, rect.origin.y + ((rect.size.height/2)-(fnt.xHeight/2)) + fnt.descender);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment:NSRightTextAlignment];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,fnt,NSFontAttributeName,color,NSForegroundColorAttributeName, nil];
    NSSize s = [text sizeWithAttributes:attr];
    pt.x = rect.origin.x + (rect.size.width - s.width - 1);
    
    [text drawAtPoint:pt withAttributes:attr];
    [style release];
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

- (void) drawText:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color
{
    if(text == nil) return;
    [[NSGraphicsContext currentContext] saveGraphicsState];
    NSRectClip(rect);
    
    NSFont *fnt = [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
    
    NSPoint pt = NSMakePoint(rect.origin.x, rect.origin.y + ((rect.size.height/2)-(fnt.xHeight/2)) + fnt.descender);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,fnt,NSFontAttributeName,color,NSForegroundColorAttributeName,nil];
    //	NSSize s = [text sizeWithAttributes:attr];
    pt.x = rect.origin.x;
    
    [text drawAtPoint:pt withAttributes:attr];
    [style release];
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}


-(void)dealloc
{
    if(xAxisLocation)
        [xAxisLocation release];
    if(xData)
        [xData release];
    [super dealloc];
}

@end
