//
//  BasicDraw.h
//  draw
//
//  Created by IvanGan on 15/7/6.
//  Copyright (c) 2015年 IA. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct Axis_Line
{
    NSPoint start;//start point in rect
    NSPoint end;//end point in rect
    int len;//line length
    int origion;//origion in rect
    int disCal;//distace for cal point
    int origionValue;//data of origion
};

@interface BasicDraw : NSView
{
    struct Axis_Line x_Axis;
    struct Axis_Line y_Axis;
    
    NSMutableArray * xAxisLocation;//x Axis location. For mark time stamp
}

@property(assign)int maxValue;
@property(assign)int minValue;
@property(retain)NSArray * data;
@property(retain)NSMutableArray * xData;
@property(assign)int gapOfSide;
@property(assign)int xOrigion;
@property(assign)int yOrigion;

@property(assign)int xLabelGap;
@property(assign)int yLabelGap;
@property(assign)int xLabelWidth;
@property(assign)int yLabelWidth;

@property(retain)NSString * baseInfo;
@property NSPoint origin;

@property(assign) BOOL labelEnable;
@property(assign) BOOL xGrideEnable;
@property(assign) BOOL yGrideEnable;
//Action
-(void)saveImage:(NSString*)file;

//draw XY
-(int)calXPosition:(long)cnt Index:(long)index;
-(NSPoint)dataToPoint:(float)value Count:(long)cnt Index:(float)index;
-(void)drawWaveForm:(NSArray*)array lineColor:(NSColor*)color lineWidth:(CGFloat)lineWidth;
-(void)draw_X_Y:(NSRect)bounds lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth XName:(NSString*)XN YName:(NSString*)YN;
-(void)draw_X_Grid:(NSRect)bounds Label:(NSMutableArray*)lbl txtColor:(NSColor*)txtColor lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth;//||||
-(void)drawYLowerPart:(NSBezierPath*)bp :(int)uValue :(int)lValue :(NSColor*)txtColor;
-(void)drawYUpperPart:(NSBezierPath*)bp :(int)uValue :(int)lValue :(NSColor*)txtColor;
-(void)draw_Y_Grid:(NSRect)bounds txtColor:(NSColor*)txtColor lineColor:(NSColor*)lineColor lineWidht:(CGFloat)lineWidth;//----

//Draw Rect
- (NSRect) waveRect;
- (void) drawRoundRect:(NSRect)bounds fillColor:(NSColor *)fillColor strokeColor:(NSColor *)strokeColor radius:(CGFloat)radius lineWidht:(CGFloat)lineWidth;

//Draw Text
- (void) drawTextCentered:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color;
- (void) drawTextRight:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color;
- (void) drawText:(NSString *)text inRect:(NSRect)rect color:(NSColor *)color;





@end
