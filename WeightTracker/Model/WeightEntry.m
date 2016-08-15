//
//  WeightEntry.m
//  WeightTracker
//
//  Created by nadine hachouche on 8/15/16.
//  Copyright © 2016 nadine hachouche. All rights reserved.
//

#import "WeightEntry.h"

static const float LBS_PER_KG = 2.2f;
static NSNumberFormatter* formatter;

@implementation WeightEntry

#pragma Init Methods

+ (void)initialize
{
    if (self == [WeightEntry class]) {
        formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMinimum:[NSNumber numberWithFloat:0.0]];
        [formatter setMaximumFractionDigits:2];
    }
}

-(id) initWithWeight:(float)weight usingUnits:(WeightUnit)unit forDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        if(unit == weight) {
            _weightInLbs = weight;
        } else {
            _weightInLbs = [WeightEntry convertLbsToKg:weight];
        }
        _date = date;
    }
    return self;
}

-(id) init
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0.0];
    return [self initWithWeight:0.0 usingUnits:LBS forDate:date];
}

+ (instancetype) entryWithWeight:(float)weight usingUnits:(WeightUnit)unit forDate:(NSDate *)date
{
    return [[self alloc]initWithWeight:weight usingUnits:unit forDate:date];
}

+ (float)convertLbsToKg:(float)lbs
{
    return lbs/LBS_PER_KG;
}

+ (float) convertKgtoLbs:(float)kg
{
    return kg * LBS_PER_KG;
}

+ (NSString *)stringForUnit:(WeightUnit)unit
{
    switch (unit) {
        case LBS:
            return @"lbs";
            break;
        case KG:
            return @"kg";
        default:
            [NSException raise:NSInvalidArgumentException format:@"NOT VALID UNIT FOR WEIGHT"];
    }
}

- (float)weightInUnit:(WeightUnit)unit
{
    switch (unit)
    {
        case LBS:
            return self.weightInLbs;
            
        case KG:
            return [WeightEntry convertLbsToKg:self.weightInLbs];
            
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"The value %d is not a valid WeightUnit", unit];
    }
}

+ (NSString*)stringForWeight:(float)weight ofUnit:(WeightUnit)unit
{
    NSString* weightString =
    [formatter stringFromNumber:@(weight)];
    
    NSString* unitString = [WeightEntry stringForUnit:unit];
    
    return [NSString stringWithFormat:@"%@ %@",
            weightString,
            unitString];
}

+ (NSString*)stringForWeightInLbs:(float)weight inUnit:(WeightUnit)unit
{
    float convertedWeight;
    switch (unit)
    {
        case LBS:
            convertedWeight = weight;
            break;
        case KG:
            convertedWeight = [WeightEntry convertLbsToKg:weight];
            break;
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"%d is not a valid WeightUnit", unit];
    }
    
    return [WeightEntry stringForWeight:convertedWeight ofUnit:unit];
}

-(NSString *)stringForWeightInUnit:(WeightUnit)unit
{
    return [WeightEntry stringForWeight:[self weightInUnit:unit] ofUnit:unit];
}

-(NSString *)description
{
    NSString *date = [NSDateFormatter
                      localizedStringFromDate:self.date
                      dateStyle:NSDateFormatterMediumStyle
                      timeStyle:NSDateFormatterShortStyle];
    
    return [NSString stringWithFormat:@"%0.2f lbs entry from %@", self.weightInLbs, date];
}


@end
