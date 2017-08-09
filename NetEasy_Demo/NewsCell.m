//
//  NewsCell.m
//  NetEasy_Demo
//
//  Created by qian88 on 16/11/15.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *recSourceLab;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLab;



@end

@implementation NewsCell

-(void)refreshUI:(News *)newsModel{
    [self.leftImageview sd_setImageWithURL:[NSURL URLWithString:newsModel.img]];
    self.titleLab.text =newsModel.title;
    self.recSourceLab.text = newsModel.recSource;
    //self.replyCountLab.text =newsModel.replyCount;
    self.replyCountLab.text =[NSString stringWithFormat:@"%@跟帖",newsModel.replyCount];
    
    
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
