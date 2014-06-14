//
//  Math.h
//  SpriteKitForBeginners
//
//  Created by Ethan Sherr on 2/13/14.
//  Copyright (c) 2014 Ethan Sherr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX      0x100000000

@protocol Math <NSObject>

static inline CGPoint esAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint esSub(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint esMult(CGPoint a, float b)
{
    return CGPointMake(a.x*b, a.y*b);
}

static inline float esLength(CGPoint a)
{
    return sqrtf(a.x * a.x + a.y*a.y);
}

static inline float esVectorToDegrees(CGPoint v)
{
    float d = atan2(v.x, v.y)*180/M_PI;
    return d;
}

//assumes normal coordinate system 0 rotation being x axis positive right hand.
static inline float esVectorToRadians(CGPoint v)
{
    float r = atan2(v.x, v.y);
    return r;
}

static inline CGPoint esNormalize(CGPoint a)
{
    float length = esLength(a);
    return CGPointMake(a.x/length, a.y/length);
}

static inline NSInteger esRandomNumberIn(int min, int max)
{
    return min + arc4random() % (max - min);
}
static inline CGFloat esRandomFloatIn(float min, float max)
{
    float f =  ((double)arc4random() / ARC4RANDOM_MAX)*(max-min)+min;
    return f;
}

static inline int esSignOf(float value)
{
    return (fabsf(value)/value > 0 ? 1 : -1);
}


static BOOL esLineSegmentIntersection(CGPoint p0, CGPoint p1,
                                  CGPoint p2, CGPoint p3,
                                  float *i_x, float *i_y)
{
    float p1_x = p1.x;
    float p1_y = p1.y;
    float p0_x = p0.x;
    float p0_y = p0.y;
    float p2_x = p2.x;
    float p2_y = p2.y;
    float p3_x = p3.x;
    float p3_y = p3.y;
    
    float s1_x, s1_y, s2_x, s2_y;
    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;
    
    float s, t;
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
    
    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
        // Collision detected
        if (i_x != NULL)
            *i_x = p0_x + (t * s1_x);
        if (i_y != NULL)
            *i_y = p0_y + (t * s1_y);
        return YES;
    }
    
    return NO; // No collision
}


static CGPoint esBezierCurveValueAtPercent(CGFloat T, CGPoint p1, CGPoint c1, CGPoint c2, CGPoint p2)
{
    CGPoint a = p1;
    CGPoint b = c1;
    
    CGPoint d = p2;
    CGPoint c = c2;
    
    
    CGFloat x = ((1 - T) * (1 - T) * (1 - T)) * a.x
    + 3 * ((1 - T) * (1 - T)) * T * b.x
    + 3 * (1 - T) * (T * T) * c.x
    + (T * T * T) * d.x;
    
    CGFloat y = ((1 - T) * (1 - T) * (1 - T)) * a.y
    + 3 * ((1 - T) * (1 - T)) * T * b.y
    + 3 * (1 - T) * (T * T) * c.y
    + (T * T * T) * d.y;
    
    return CGPointMake(x, y);
}


static CGFloat esBezierCurveLengthWithIterations(NSInteger len, CGPoint p1, CGPoint c1, CGPoint c2, CGPoint p2)
{
    float INC = 1.0f/len;
    
    CGPoint p0 = esBezierCurveValueAtPercent(0, p1, c1, c2, p2); //getValueAt_T:0 p1:p1 c1:c1 c2:c2 p2:p2];
    float clen = 0;
    for (int i = 1; i <= len; i++)
    {
        CGPoint p = esBezierCurveValueAtPercent(i*INC, p1, c1, c2, p2);//[self getValueAt_T:(i*INC) p1:p1 c1:c1 c2:c2 p2:p2];
        CGPoint dxy = CGPointMake(p0.x - p.x, p0.y - p.y);
        clen += sqrtf(dxy.x*dxy.x + dxy.y*dxy.y);
        
        p0.x = p.x;
        p0.y = p.y;
    }
    return clen;
}

static CGFloat esBezierCurveLength(CGPoint p1, CGPoint c1, CGPoint c2, CGPoint p2)
{
    return esBezierCurveLengthWithIterations(20, p1, c1, c2, p2);
}






@end
