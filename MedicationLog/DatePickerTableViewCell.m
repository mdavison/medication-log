//
//  DatePickerTableViewCell.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/18/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "DatePickerTableViewCell.h"

@implementation DatePickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.datePicker.maximumDate = [NSDate date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
