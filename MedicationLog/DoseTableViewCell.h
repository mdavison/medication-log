//
//  DoseTableViewCell.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/22/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicationLabel;

@end
