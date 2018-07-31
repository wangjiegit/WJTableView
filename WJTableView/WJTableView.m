//
//  WJTableView.m
//  WJTableView
//
//  Created by 王杰 on 2018/7/31.
//  Copyright © 2018年 王杰. All rights reserved.
//

#import "WJTableView.h"

@interface WJTableView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) CGFloat imageViewHeight;

@end

@implementation WJTableView

- (void)setImageName:(NSString *)imageName {
    if (_imageName == imageName) return;
        _imageName = imageName;
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) return;
    self.imageView.image = image;
    self.imageViewHeight = CGRectGetWidth(self.frame) * (image.size.height / image.size.width);
    self.imageView.frame = CGRectMake(0, -self.imageViewHeight, self.frame.size.width, self.imageViewHeight);
    self.contentInset = UIEdgeInsetsMake(self.imageViewHeight, 0, 0, 0);
    if (![self.subviews containsObject:self.imageView]) {
        [self addSubview:self.imageView];
        [self addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat contentOffsetY = point.y;
        CGRect rect = self.imageView.frame;
        if (contentOffsetY < -self.imageViewHeight) {
            rect.origin.y = contentOffsetY;
            rect.size.height = -contentOffsetY;
        } else {
            rect.origin.y = -self.imageViewHeight;
            rect.size.height = self.imageViewHeight;;
        }
        self.imageView.frame = rect;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
