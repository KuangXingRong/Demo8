//
//  UIScrollView+Refresh.m
//  HeaderRefresh
//
//  Created by ios on 2018/1/7.
//  Copyright © 2018年 LZQ. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "CustomRefreshHeader.h"
#import "CustomerRefreshFooter.h"

static void *headerRefreshKey = &headerRefreshKey;
static void *footerRefreshKey  = &footerRefreshKey;
static void *configRefreshKey = &configRefreshKey;
static void *currentPageKey = &currentPageKey;
static void *totalPageKey = &totalPageKey;
static void *footerEndingKey = &footerEndingKey;
static void *hideTypeKey = &hideTypeKey;

@implementation UIScrollView (Refresh)

- (NSInteger)demandPage {
    return [objc_getAssociatedObject(self, currentPageKey) integerValue];
}

- (void)setDemandPage:(NSInteger)demandPage {
    objc_setAssociatedObject(self, currentPageKey, @(demandPage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)totalPages {
    return [objc_getAssociatedObject(self, totalPageKey) integerValue];
}

- (void)setTotalPages:(NSInteger)totalPages {
    objc_setAssociatedObject(self, totalPageKey, @(totalPages), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (totalPages != 0) {
        self.headerRefresh = NO;
        if (totalPages > self.demandPage) {
            self.footerRefresh = YES;
        }
        self.footerEnding = (self.demandPage >= totalPages);
        self.demandPage += 1;
    } else {
        self.headerRefresh = NO;
        self.footerEnding = NO;
    }
}

- (id<ConfigRefreshDelegate>)configRefreshDelegate {
    return objc_getAssociatedObject(self, configRefreshKey);
}

- (void)setConfigRefreshDelegate:(id<ConfigRefreshDelegate>)configRefreshDelegate {
    objc_setAssociatedObject(self, configRefreshKey, configRefreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)headerRefresh {
    return  [objc_getAssociatedObject(self, headerRefreshKey) integerValue];
}

- (void)setHeaderRefresh:(BOOL)headerRefresh {
    objc_setAssociatedObject(self, headerRefreshKey, @(headerRefresh), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (headerRefresh) {
        if (!self.mj_header) {
            //LFRefreshHeader
//            self.mj_header = [CustomRefreshHeader headerWithRefreshingBlock:^{
//                self.demandPage = 1;
//                [self.configRefreshDelegate headerRefresh:self];
//            }];
            
            self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.demandPage = 1;
                [self.configRefreshDelegate headerRefresh:self];
            }];
        }
        [self.mj_header beginRefreshing];
    } else {
        if (self.mj_header) {
            [self.mj_header endRefreshing];
        }
    }
}

- (BOOL)footerRefresh {
     return  [objc_getAssociatedObject(self, footerRefreshKey) integerValue];
}

- (void)setFooterRefresh:(BOOL)footerRefresh {
    objc_setAssociatedObject(self, footerRefreshKey, @(footerRefresh), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (footerRefresh) {
        self.headerRefresh = NO;
        if (!self.mj_footer) {
//            self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                [self.configRefreshDelegate footerRefresh:self];
//            }];
            CustomerRefreshFooter *footer = [CustomerRefreshFooter footerWithRefreshingBlock:^{
                [self.configRefreshDelegate footerRefresh:self];
            }];
            footer.stateLabel.hidden = YES;
            self.mj_footer = footer;

        }
        self.footerEnding = NO;
    } else {
        self.headerRefresh = NO;
        self.footerEnding = YES;
        
    }
}

- (BOOL)footerEnding {
    return [objc_getAssociatedObject(self, footerEndingKey) integerValue];
}

- (void)setFooterEnding:(BOOL)footerEnding {
    objc_setAssociatedObject(self, footerEndingKey, @(footerEnding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.mj_footer != nil) {
//        if (footerEnding) {
//            [self.mj_footer endRefreshingWithNoMoreData];
//        } else {
//            [self.mj_footer endRefreshing];
//        }
        [self.mj_footer endRefreshing];
    }
}

- (RefreshHideType)hideType {
    return [objc_getAssociatedObject(self, hideTypeKey) integerValue];
}

- (void)setHideType:(RefreshHideType)hideType{
    objc_setAssociatedObject(self, hideTypeKey, @(hideType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.mj_header && hideType == RefreshHideTypeHeader) {
        self.mj_header = nil;
    }
    if (self.mj_footer && hideType == RefreshHideTypeFooter) {
        self.mj_footer = nil;
    }
    if (hideType == RefreshHideTypeAll) {
        if (self.mj_header) {
            self.mj_header = nil;
        }
        if (self.mj_footer) {
            self.mj_footer = nil;
        }        
    }
}




@end
