//
//  WeightHistoryDocument.m
//  WeightTracker
//
//  Created by nadine hachouche on 8/15/16.
//  Copyright © 2016 nadine hachouche. All rights reserved.
//

#import "WeightHistoryDocument.h"
#import "WeightEntry.h"
#import <UIKit/UIKit.h>

// Use to register for update notifications
NSString * const WeightHistoryDocumentBeginChangesNotification =
@"WeightHistoryDocumentBeginChangesNotification";

NSString * const WeightHistoryDocumentInsertWeightEntryNotification =
@"WeightHistoryDocumentInsertWeightEntryNotification";

NSString * const WeightHistoryDocumentDeleteWeightEntryNotification =
@"WeightHistoryDocumentDeleteWeightEntryNotification";

NSString * const WeightHistoryDocumentChangesCompleteNotification =
@"WeightHistoryDocumentChangesCompleteNotification";

// Use to access data in the notifications
NSString * const WeightHistoryDocumentNotificationIndexPathKey =
@"WeightHistoryDocumentNotificationIndexPathKey";

@interface WeightHistoryDocument()
@property (strong, nonatomic)NSMutableArray *weightHistory;
@end

@implementation WeightHistoryDocument

#pragma mark - Initialization Methods

- (id)init
{
    self = [super init];
    if (self) {
        _weightHistory = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Accessor Methods

-(NSUInteger)count
{
    return [self.weightHistory count];
}

+ (NSSet *)keyPathsForValuesAffectingCount
{
    return [NSSet setWithObjects:@"weightHistory", nil];
}

#pragma mark - KVO Accessors
- (void)insertObject:(WeightEntry *)object inWeightHistoryAtIndex:(NSUInteger)index
{
    [self.weightHistory insertObject:object atIndex:index];
}

- (void)removeObjectFromWeightHistoryAtIndex:(NSUInteger)index
{
    [self.weightHistory removeObjectAtIndex:index];
}

#pragma mark - Public Methods

- (WeightEntry *)entryAtIndexPath:(NSIndexPath *)indexPath
{
    return self.weightHistory[(NSUInteger)indexPath.row];
}

- (NSIndexPath *)indexPathForEntry:(WeightEntry *)weightEntry
{
    NSUInteger row = [self.weightHistory indexOfObject:weightEntry];
    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

- (void)addEntry:(WeightEntry *)weightEntry
{
    NSUInteger index = [self insertionPointForDate:weightEntry.date];
    NSIndexPath *indexPath =
    [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center
     postNotificationName:WeightHistoryDocumentBeginChangesNotification
     object:self];
    
    [self insertObject:weightEntry inWeightHistoryAtIndex:index];
    
    [center
     postNotificationName:WeightHistoryDocumentInsertWeightEntryNotification
     object:self
     userInfo:@{WeightHistoryDocumentNotificationIndexPathKey:indexPath}];
    
    [center
     postNotificationName:WeightHistoryDocumentChangesCompleteNotification
     object:self];
}

- (void)deleteEntryAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center
     postNotificationName:WeightHistoryDocumentBeginChangesNotification
     object:self];
    
    [self removeObjectFromWeightHistoryAtIndex:(NSUInteger)indexPath.row];
    
    [center
     postNotificationName:WeightHistoryDocumentDeleteWeightEntryNotification
     object:self
     userInfo:@{WeightHistoryDocumentNotificationIndexPathKey:indexPath}];
    
    [center
     postNotificationName:WeightHistoryDocumentChangesCompleteNotification
     object:self];
}

- (void)enumerateEntriesAscending:(BOOL)ascending withBlock:(EntryEnumeratorBlock)block
{
    NSUInteger options = 0;
    if (ascending) {
        options = NSEnumerationReverse;
    }
    
    [self.weightHistory enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (NSArray *)weightEntriesAfter:(NSDate *)startDate before:(NSDate *)endDate
{
    
    NSPredicate *betweenDates =
    [NSPredicate predicateWithBlock:^BOOL(WeightEntry *entry,
                                          NSDictionary *bindings) {
        return ([entry.date compare:startDate] != NSOrderedAscending) &&
        ([entry.date compare:endDate] != NSOrderedDescending);
    }];
    
    
    return [self.weightHistory filteredArrayUsingPredicate:betweenDates];
}

#pragma mark - NSObject Methods

-(NSString *)description
{
    return [NSString stringWithFormat:@"WeightHistoryDocument: count = %@, history = %@",
            @(self.count), self.weightHistory];
}

#pragma mark - Private Methods

- (NSUInteger)insertionPointForDate:(NSDate *)date
{
    NSUInteger index = 0;
    for (WeightEntry *entry in self.weightHistory)
    {
        if ([date compare:entry.date] == NSOrderedDescending)
        {
            return index;
        }
        index++;
    }
    return index;
}

@end
