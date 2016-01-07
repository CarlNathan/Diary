//
//  EntryCell.m
//  Diary
//
//  Created by Carl Udren on 1/6/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "EntryCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;


@end

@implementation EntryCell

+ (CGFloat)heightForEntry:(DiaryEntry *)entry{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 45.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boudingBox = [entry.body boundingRectWithSize:CGSizeMake(219, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boudingBox)+topMargin+bottomMargin);
}

- (void)configureCellForEntry:(DiaryEntry *)entry{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMM d, yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if(entry.imageData){
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    }else{
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if (entry.mood == diaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    }else if (entry.mood == diaryEntryMoodAverage){
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }else if (entry.mood == diaryEntryMoodBad){
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame) / 2.0f;
    
    if (entry.location) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No location";
    }
}

@end
