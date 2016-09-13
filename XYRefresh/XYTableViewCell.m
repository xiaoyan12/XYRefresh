//
//  XYTableViewCell.m
//  XYRefresh
//
//  Created by 闫世超 on 16/9/12.
//  Copyright © 2016年 闫世超. All rights reserved.
//

#import "XYTableViewCell.h"
#import "XYModel.h"

@interface XYTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@end

@implementation XYTableViewCell


-(void)setModel:(XYModel *)model{
    _model = model;
    _lable.text = model.title;
    NSURL *url = [NSURL URLWithString:model.pic];
    [_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
