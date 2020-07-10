//
//  QLLiveComponentLayout.m
//  BanBanLive
//
//  Created by skynet on 2020/3/31.
//  Copyright © 2020 伴伴网络. All rights reserved.
//

#import "QLLiveComponentLayout.h"

typedef NS_ENUM(NSUInteger, QLLiveComponentSemantic) {
    
    QLLiveComponentSemanticNormal,
    
    QLLiveComponentSemanticEmbed,
    QLLiveComponentSemanticFixed,
};

@interface QLLiveComponentDistribution ()

@property (nonatomic, readwrite) NSInteger value;
@property (nonatomic) QLLiveComponentSemantic semantic;

@property (nonatomic, readonly) BOOL isEmbed;
@end

@interface QLLiveComponentItemRatio ()

@property (nonatomic, readwrite) CGFloat value;
@property (nonatomic) QLLiveComponentSemantic semantic;

@property (nonatomic, readonly) BOOL isFixed;
@end

@implementation QLLiveComponentLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _insets = UIEdgeInsetsZero;
        _interitemSpacing = 5.0f;
        _lineSpacing = 5.0f;
    }
    return self;
}

- (void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
    _insetContainerWidth = [UIScreen mainScreen].bounds.size.width
    - self.insets.left - self.insets.right;
}

- (CGSize)itemSize{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    CGFloat componentWidth = self.insetContainerWidth;
    
    // distribution -> width
    if (nil == self.distribution) {
        self.distribution = [QLLiveComponentDistribution distributionValue:2];
    }
    NSInteger count = MAX(1, self.distribution.value);
    width = (componentWidth - (count - 1) * self.interitemSpacing) / count;
    
    // itemRatio -> height
    if (nil == self.itemRatio) {
        self.itemRatio = [QLLiveComponentItemRatio itemRatioValue:1];
    }
    if (self.itemRatio.isFixed) {
        height = self.itemRatio.value;
    } else {
        height = width / MAX(0.01, self.itemRatio.value);
    }
    
    // 如果有默认占位视图高度
    if (self.placeholdHeight) {
        height = self.placeholdHeight;
        width = componentWidth;
    }

    return CGSizeMake(width, height);
}

- (CGSize)itemSizeAtIndex:(NSInteger)index{
    
    CGSize itemSize = CGSizeZero;

    if (!_cacheItemSize) {
        _cacheItemSize = [NSMutableDictionary new];
    }
    NSString * key = [NSString stringWithFormat:@"cache_%ld_itemSize_key",(long)index];
    if ([_cacheItemSize.allKeys containsObject:key]) {
        itemSize = [_cacheItemSize[key] CGSizeValue];
    } else {
        if ([self.customItemSize respondsToSelector:@selector(componentLayoutCustomItemSize:atIndex:)]) {
            itemSize = [self.customItemSize componentLayoutCustomItemSize:self atIndex:index];
        } else {
            itemSize = [self itemSize];
        }
        _cacheItemSize[key] = [NSValue valueWithCGSize:itemSize];
    }
    return itemSize;;
}

- (void) clear{
    [_cacheItemSize removeAllObjects];
    _cacheItemSize = [NSMutableDictionary new];
}
@end

@implementation QLLiveComponentDistribution

+ (instancetype)distributionValue:(NSInteger)distribution{
    return [[self alloc] initWithDistribution:distribution
                                     semantic:QLLiveComponentSemanticNormal];
}

- (instancetype)initWithDistribution:(NSInteger)distribution semantic:(QLLiveComponentSemantic)semantic {

    self = [super init];
    if (self) {
        self.value = distribution;
        self.semantic = semantic;
    }
    return self;;
}

- (BOOL)isEmbed{
    return self.semantic == QLLiveComponentSemanticEmbed;
}

@end

@implementation QLLiveComponentItemRatio

+ (instancetype)itemRatioValue:(CGFloat)value{
    if (value <= 0) {
        return nil;
    }
    return [[self alloc] initWithItemRatio:value semantic:QLLiveComponentSemanticNormal];
}

+ (instancetype)fixedValue:(CGFloat)value{
    if (value <= 0) {
        return nil;
    }
    return [[self alloc] initWithItemRatio:value semantic:QLLiveComponentSemanticFixed];
}

- (instancetype)initWithItemRatio:(CGFloat)itemRatio semantic:(QLLiveComponentSemantic)semantic {

    self = [super init];
    if (self) {
        self.value = itemRatio;
        self.semantic = semantic;
    }
    return self;;
}

- (BOOL)isFixed{
    return self.semantic == QLLiveComponentSemanticFixed;
}
@end
