#import "RnCryptopp.h"
#import <React/RCTBridge+Private.h>
#import <React/RCTUtils.h>
#import <jsi/jsi.h>
#import "react-native-rn-cryptopp.h"
#import <sys/utsname.h>

using namespace facebook::jsi;

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
}

- (NSString *)getModel {

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

//        String deviceName =
//            convertNSStringToJSIString(runtime, [simpleJsi getModel]);
        String deviceName = String::createFromUtf8(runtime, [[cryptoPp getModel] UTF8String] ?: "");
        return Value(runtime, deviceName);
  });
    
  jsiRuntime.global().setProperty(jsiRuntime, "getDeviceName", std::move(getDeviceName));

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
