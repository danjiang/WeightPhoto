//
//  DTEventToWeight.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-12.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTEventToWeight.h"
#import "DTFileManager.h"

@implementation DTEventToWeight

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error {
    if ([super createDestinationInstancesForSourceInstance:sInstance entityMapping:mapping manager:manager error:error]) {
        NSManagedObjectContext *moc = manager.destinationContext;
        
        NSString *photoFilePath = [sInstance valueForKey:@"photoFilePath"];
        if (photoFilePath) {
            NSString *date = [sInstance valueForKey:@"date"];
            NSURL *photo = [[DTFileManager sharedInstance] documentDirectoryAppendingFilePath:photoFilePath];
            
            NSManagedObject *object = [self findWeightRecordByDate:date moc:moc];
            
            [object setValue:[NSData dataWithContentsOfURL:photo] forKey:@"image"];
            NSError *err = nil;
            if(![moc save:&err]) {
                NSLog(@"add image to weight for date %@ error: %@", date, err);
            }
            [[DTFileManager sharedInstance] removeItemAtURL:photo];
        }
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Private Helper Method

- (NSManagedObject *)findWeightRecordByDate:(NSString *)date moc:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    fetchRequest.fetchLimit = 1;
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return (array && [array count] > 0) ? [array objectAtIndex:0] : nil;
}

@end
