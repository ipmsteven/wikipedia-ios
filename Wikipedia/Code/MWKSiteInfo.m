//
//  MWKSiteInfo.m
//  Wikipedia
//
//  Created by Brian Gerstle on 5/29/15.
//  Copyright (c) 2015 Wikimedia Foundation. All rights reserved.
//

#import "MWKSiteInfo.h"
#import "NSObjectUtilities.h"
#import "MediaWikiKit.h"

typedef NS_ENUM (NSUInteger, MWKSiteInfoNSCodingSchemaVersion) {
    MWKSiteInfoNSCodingSchemaVersion_1 = 1
};

static NSString* const MWKSiteInfoNSCodingSchemaVersionKey = @"siteInfoSchemaVersion";

NS_ASSUME_NONNULL_BEGIN

@interface MWKSiteInfo ()
@property (readwrite, copy, nonatomic) NSURL* siteURL;
@property (readwrite, copy, nonatomic) NSString* mainPageTitleText;
@end

@implementation MWKSiteInfo

- (instancetype)initWithSiteURL:(NSURL*)siteURL
                mainPageTitleText:(NSString*)mainPage {
    self = [super init];
    if (self) {
        self.siteURL         = [siteURL wmf_siteURL];
        self.mainPageTitleText = mainPage;
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ {"
            "\t site: %@,\n"
            "\t mainPage: %@ \n"
            "}\n", [super description], self.siteURL, self.mainPageTitleText];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if ([object isKindOfClass:[MWKSiteInfo class]]) {
        return [self isEqualToSiteInfo:object];
    } else {
        return NO;
    }
}

- (BOOL)isEqualToSiteInfo:(MWKSiteInfo*)siteInfo {
    return WMF_EQUAL_PROPERTIES(self, siteURL, isEqual:, siteInfo)
           && WMF_EQUAL_PROPERTIES(self, mainPageTitleText, isEqualToString:, siteInfo);
}

- (NSUInteger)hash {
    return self.siteURL.hash ^ flipBitsWithAdditionalRotation(self.mainPageTitleText.hash, 1);
}

#pragma mark - Computed Properties

- (NSURL*)mainPageURL {
    return [self.siteURL wmf_URLWithTitle:self.mainPageTitleText];
}

@end

NS_ASSUME_NONNULL_END
