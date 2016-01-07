//
//  EntryCell.h
//  Diary
//
//  Created by Carl Udren on 1/6/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryCell : UITableViewCell

+(CGFloat)heightForEntry:(DiaryEntry *)entry;

- (void) configureCellForEntry:(DiaryEntry*)entry;

@end
