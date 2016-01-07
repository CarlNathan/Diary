//
//  EntryViewController.m
//  Diary
//
//  Created by Carl Udren on 1/4/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "EntryViewController.h"
#import "DiaryEntry+CoreDataProperties.h"
#import "CoreDataStack.h"
#import <CoreLocation/CoreLocation.h>

@interface EntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) enum DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (strong, nonatomic) UIImage *pickedImage;



@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        self.pickedImage = [UIImage imageWithData:self.entry.imageData];

    } else {
        self.pickedMood = diaryEntryMoodAverage;
        date = [NSDate date];
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textView.inputAccessoryView = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = (NSString *)placemark;
        NSLog(@"%@", self.location);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)promptForSource{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Choose Photo Source"
                                          message:@"Please Select either Camera or Photo Roll"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    UIAlertAction *photoRollAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Photo Roll", @"Photo Roll action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self promptForPhotoRoll];
                               }];
    UIAlertAction *cameraAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Camera", @"Camera action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self promptForCamera];
                               }];

    
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:photoRollAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}

- (void)setPickedMood:(enum DiaryEntryMood)pickedMood{
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case diaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
            
        case diaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        
        case diaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
    }


}

- (IBAction)doneWasPressed:(id)sender {
    if (self.entry !=nil) {
        [self updateDiaryEntry];
    }else{
        
    [self insertDiaryEntry];
    }
    [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDiaryEntry{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.location = self.location;
    entry.mood = self.pickedMood;
    [coreDataStack saveContext];
}

- (void) updateDiaryEntry{
    self.entry.body = self.textView.text;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    self.entry.mood = self.pickedMood;
    

    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
    
}

- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = diaryEntryMoodBad;
}
- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = diaryEntryMoodAverage;
}
- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = diaryEntryMoodGood;
}

- (IBAction)imageButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}


@end
