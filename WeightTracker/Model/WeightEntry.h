//
//  WeightEntry.h
//  WeightTracker
//
//  Created by nadine hachouche on 8/15/16.
//  Copyright © 2016 nadine hachouche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightUnits.h"

@interface WeightEntry : NSObject

@property (assign, nonatomic, readonly) float weightInLbs;
@property (assign, nonatomic, readonly) NSDate* date;

+ (instancetype)entryWithWeight:(float)weight usingUnits:(WeightUnit)unit forDate:(NSDate *)date;
+ (float) convertLbsToKg:(float)lbs;
+ (float) convertKgtoLbs:(float)kg;

+ (NSString *)stringForUnit:(WeightUnit)unit;
+ (NSString *)stringForWeight:(float)weight ofUnit:(WeightUnit)unit;
+ (NSString *)stringForWeightInLbs:(float)weight inUnit:(WeightUnit)unit;

- (float)weightInUnit:(WeightUnit)unit;
- (NSString *)stringForWeightInUnit:(WeightUnit)unit;

@end
