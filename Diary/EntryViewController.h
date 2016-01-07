//
//  EntryViewController.h
//  Diary
//
//  Created by Carl Udren on 1/4/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryViewController : UIViewController

@property(nonatomic, strong) DiaryEntry *entry;

@end
