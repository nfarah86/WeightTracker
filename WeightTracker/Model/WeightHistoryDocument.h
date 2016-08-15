//
//  WeightHistoryDocument.h
//  WeightTracker
//
//  Created by nadine hachouche on 8/15/16.
//  Copyright © 2016 nadine hachouche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightUnits.h"

@class WeightEntry;
typedef void (^EntryEnumeratorBlock) (WeightEntry *entry);

extern NSString * const WeightHistoryDocumentBeginChangesNotification;
extern NSString * const WeightHistoryDocumentInsertWeightEntryNotification;
extern NSString * const WeightHistoryDocumentDeleteWeightEntryNotification;
extern NSString * const WeightHistoryDocumentChangesCompleteNotification;

// Use to access data in the notifications
extern NSString * const WeightHistoryDocumentNotificationIndexPathKey;

@interface WeightHistoryDocument : NSObject
@property(nonatomic, readonly) NSUInteger count;

-(WeightEntry *)entryAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPathForEntry:(WeightEntry *)weightEntry;
-(void)addEntry:(WeightEntry *)weightEntry;
-(void)deleteEntryAtIndexPath:(NSIndexPath *)indexPath;

-(void)enumerateEntriesAscending:(BOOL)ascending withBlock:(EntryEnumeratorBlock)block;
-(NSMutableArray *)weightEntriesAfter:(NSDate *)startDate before:(NSDate *)endDate;
@end
