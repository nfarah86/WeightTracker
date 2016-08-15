//
//  WeightUnits.h
//  WeightTracker
//
//  Created by nadine hachouche on 8/15/16.
//  Copyright © 2016 nadine hachouche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LBS,
    KG
} WeightUnit;

WeightUnit getDefaultUnits(void);
