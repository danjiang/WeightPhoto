//
//  DTUnitConverter.h
//  WeightPhoto
//
//  Created by 但 江 on 12-7-18.
//  Copyright (c) 2012年 Dan Thought Studio. All rights reserved.
//

@interface DTUnitConverter : NSObject

+ (instancetype)sharedInstance;
- (float)inchWithMeter:(float)m;
- (float)meterWithInch:(float)inch;
- (float)poundWithKilo:(float)kilo;
- (float)kiloWithPound:(float)pound;
- (float)bmiWithWeight:(float)weight height:(float)height;
- (float)roundToOneDecimal:(float)f;

@end
