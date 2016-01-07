//
//  DiaryEntry.m
//  Diary
//
//  Created by Carl Udren on 1/4/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "DiaryEntry.h"

@implementation DiaryEntry

// Insert code here to add functionality to your managed object subclass

-(NSString *)sectionName{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    return [dateFormatter stringFromDate:date];
    
}

@end
