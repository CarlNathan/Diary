//
//  DiaryEntry+CoreDataProperties.h
//  Diary
//
//  Created by Carl Udren on 1/4/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DiaryEntry.h"


NS_ASSUME_NONNULL_BEGIN


@interface DiaryEntry (CoreDataProperties)

@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nonatomic) int16_t mood;
@property (nullable, nonatomic, retain) NSString *location;

@end

NS_ASSUME_NONNULL_END
