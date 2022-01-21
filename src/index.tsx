import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-rn-cryptopp' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const RnCryptopp = NativeModules.RnCryptopp
  ? NativeModules.RnCryptopp
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return RnCryptopp.multiply(a, b);
}

export function hey(a: number, b: number): Promise<number> {
  return RnCryptopp.multiply(a, b);
}

console.log('heydssd');

export default RnCryptopp;
