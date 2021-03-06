#import <Chartboost/Chartboost.h>
#import "ChartboostAdapterConfiguration.h"
#import "MPChartboostRouter.h"

#if __has_include("MoPub.h")
#import "MPLogging.h"
#endif

// Constants
static NSString * const kChartboostAppIdKey        = @"appId";
static NSString * const kChartboostAppSignatureKey = @"appSignature";

// Errors
static NSString * const kAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-chartboost-adapters";

typedef NS_ENUM(NSInteger, ChartboostAdapterErrorCode) {
    ChartboostAdapterErrorCodeMissingAppId,
    ChartboostAdapterErrorCodeMissingAppSignature,
};

@implementation ChartboostAdapterConfiguration

#pragma mark - Caching

+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    // These should correspond to the required parameters checked in
    // `initializeNetworkWithConfiguration:complete:`
    NSString * appId = parameters[kChartboostAppIdKey];
    NSString * appSignature = parameters[kChartboostAppSignatureKey];
    
    if (appId != nil && appSignature != nil) {
        NSDictionary * configuration = @{ kChartboostAppIdKey: appId, kChartboostAppSignatureKey:appSignature };
        [ChartboostAdapterConfiguration setCachedInitializationParameters:configuration];
    }
}

#pragma mark - MPAdapterConfiguration

- (NSString *)adapterVersion {
    return @"7.3.0.4";
}

- (NSString *)biddingToken {
    return nil;
}

- (NSString *)moPubNetworkName {
    return @"chartboost";
}

- (NSString *)networkSdkVersion {
    return Chartboost.getSDKVersion;
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> *)configuration
                                  complete:(void(^)(NSError *))complete {
    
    NSString * appId = configuration[kChartboostAppIdKey];
    if (appId == nil) {
        NSError * error = [NSError errorWithDomain:kAdapterErrorDomain code:ChartboostAdapterErrorCodeMissingAppId userInfo:@{ NSLocalizedDescriptionKey: @"Chartboost's initialization skipped. The appId is empty. Ensure it is properly configured on the MoPub dashboard. Note that initialization on the first app launch is a no-op." }];
        MPLogEvent([MPLogEvent error:error message:nil]);
        
        if (complete != nil) {
            complete(error);
        }
        return;
    }
    
    NSString * appSignature = configuration[kChartboostAppSignatureKey];
    if (appSignature == nil) {
        NSError * error = [NSError errorWithDomain:kAdapterErrorDomain code:ChartboostAdapterErrorCodeMissingAppSignature userInfo:@{ NSLocalizedDescriptionKey: @"Chartboost's initialization skipped. The appSignature is empty. Ensure it is properly configured on the MoPub dashboard. Note that initialization on the first app launch is a no-op." }];
        MPLogEvent([MPLogEvent error:error message:nil]);
        
        if (complete != nil) {
            complete(error);
        }
        return;
    }
    
    // Initialize the router
    [[MPChartboostRouter sharedRouter] startWithAppId:appId appSignature:appSignature];
    if (complete != nil) {
        complete(nil);
    }
}

@end
