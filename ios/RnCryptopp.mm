#import "RnCryptopp.h"
#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import <jsi/jsi.h>
#import "react-native-rn-cryptopp.h"
#import <sys/utsname.h>
#include "YeetJSIUtils.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>


using namespace facebook::jsi;
using namespace std;

@implementation RnCryptopp


@synthesize bridge = _bridge;
@synthesize methodQueue = _methodQueue;

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {

    return YES;
}

- (void)setBridge:(RCTBridge *)bridge {
    _bridge = bridge;
    _setBridgeOnMainQueue = RCTIsMainQueue();
    [self installLibrary];
}

- (void)installLibrary {

    RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self.bridge;

    if (cxxBridge.runtime) {
        example::install(*(facebook::jsi::Runtime *)cxxBridge.runtime);
    }
    install(*(facebook::jsi::Runtime *)cxxBridge.runtime, self);
}

- (NSString *)getModel {

    //    NSString *keyString = @"YXNkZg==";

    NSString *keyString = @"68sGk5CADl8MaSHjGAwEwxiismMmA1CuMqaiZAPXuNg=";
    NSString* ivString = @"SEHUOmHzgqBZZdIjWvFmAg==";
    NSString* dataInString = @"UQamOAvnwxzfrDY6UMZfJw==";
    NSData *key = [[NSData alloc] initWithBase64EncodedString:keyString  options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *iv = [[NSData alloc] initWithBase64EncodedString:ivString  options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *dataIn = [[NSData alloc] initWithBase64EncodedString:dataInString options:NSDataBase64DecodingIgnoreUnknownCharacters];

    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
    NSString* dataOutString;

    dataOutString = [[NSString alloc] initWithData:dataOut encoding:NSASCIIStringEncoding];

    NSLog(dataOutString);

//    base64 decoding test
//    NSString* fooOrig = @"YXNkZg==";
//    NSData *fooData = [[NSData alloc] initWithBase64EncodedString:fooOrig  options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSString* foo;
//    foo = [[NSString alloc] initWithData:fooData encoding:NSASCIIStringEncoding];
//    NSLog(foo);


    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES,
                       kCCOptionPKCS7Padding,
                       key.bytes,
                       kCCKeySizeAES256,
                       iv.bytes,
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);

    dataOut.length = cryptBytes;

    NSLog(@"status %i", ccStatus);


    dataOutString = [[NSString alloc] initWithData:dataOut encoding:NSASCIIStringEncoding];

    NSLog(dataOutString);

    struct utsname systemInfo;

    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void)setItem:(NSString *)key:(NSString *)value {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    [standardUserDefaults setObject:value forKey:key];

    [standardUserDefaults synchronize];
}

- (NSString *)getItem:(NSString *)key {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    return [standardUserDefaults stringForKey:key];
}

static void install(Runtime &jsiRuntime, RnCryptopp *cryptoPp) {

    auto getDeviceName = Function::createFromHostFunction(
                                                          jsiRuntime, PropNameID::forAscii(jsiRuntime, "getDeviceName"), 0,
                                                          [cryptoPp](Runtime &runtime, const Value &thisValue,
                                                                     const Value *arguments, size_t count) -> Value {

                                                                         String deviceName =
                                                                         convertNSStringToJSIString(runtime, [cryptoPp getModel]);
                                                                         //        String deviceName = String::createFromUtf8(runtime, [[cryptoPp getModel] UTF8String] ?: "");
                                                                         return Value(runtime, deviceName);
                                                                     });

    jsiRuntime.global().setProperty(jsiRuntime, "getDeviceName", move(getDeviceName));

    auto getItem = Function::createFromHostFunction(jsiRuntime,
                                                    PropNameID::forAscii(jsiRuntime,
                                                                         "getItem"),
                                                    0,
                                                    [cryptoPp](Runtime &runtime,
                                                               const Value &thisValue,
                                                               const Value *arguments,
                                                               size_t count) -> Value {

        NSString *key = convertJSIStringToNSString(runtime, arguments[0].getString(runtime));



        NSString *value = [key stringByAppendingString:@" --> from obective-c"];
        facebook::jsi::String bar = convertNSStringToJSIString(runtime, value);

        facebook::jsi::String foo = example::something(runtime, bar);

        return foo;
    });

    jsiRuntime.global().setProperty(jsiRuntime, "getItem", move(getItem));

}






@end

//RCT_EXPORT_MODULE()
//
//// Example method for C++
//// See the implementation of the example module in the `cpp` folder
//RCT_EXPORT_METHOD(multiply:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
//                  withResolver:(RCTPromiseResolveBlock)resolve
//                  withReject:(RCTPromiseRejectBlock)reject)
//{
//    NSNumber *result = @(example::multiply([a floatValue], [b floatValue]));
//
//    resolve(result);
//}
//
//@end
