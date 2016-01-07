//
//  DiaryEntry.h
//  Diary
//
//  Created by Carl Udren on 1/4/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN

extern NS_ENUM(int16_t,DiaryEntryMood){
    diaryEntryMoodGood = 0,
    diaryEntryMoodAverage = 1,
    diaryEntryMoodBad = 2};

@interface DiaryEntry : NSManagedObject


// Insert code here to declare functionality of your managed object subclass

@property(nonatomic, readonly) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END

#import "DiaryEntry+CoreDataProperties.h"