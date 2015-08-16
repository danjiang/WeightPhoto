//
//  DTUnitConverter.m
//  WeightPhoto
//
//  Created by 但 江 on 12-7-18.
//  Copyright (c) 2012年 Dan Thought Studio. All rights reserved.
//

#import "DTUnitConverter.h"

@implementation DTUnitConverter

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (float)inchWithMeter:(float)m {
    return 39.37 * m;
}

- (float)meterWithInch:(float)inch {
    return 0.0254 * inch;
}

- (float)poundWithKilo:(float)kilo {
    return 2.2046 * kilo;
}

- (float)kiloWithPound:(float)pound {
    return 0.45359 * pound;
}

- (float)bmiWithWeight:(float)weight height:(float)height {
    return  weight / (height * height);
}

- (float)roundToOneDecimal:(float)f {
    return roundf(f * 10) / 10.0;
}

@end
