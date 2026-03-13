
import { requireNativeModule } from 'expo-modules-core';
import { ExpoGaodeMapNavigationModule as ExpoGaodeMapNavigationModuleType } from './types/native-module.types';
/**
 * 高德地图导航模块
 * 
 * 提供路径规划功能，包括驾车、步行、骑行、公交、货车等多种出行方式
 */
let nativeModuleCache: ExpoGaodeMapNavigationModuleType | null = null;

function getNativeModule(): ExpoGaodeMapNavigationModuleType {
  if (!nativeModuleCache) {
    nativeModuleCache = requireNativeModule<ExpoGaodeMapNavigationModuleType>('ExpoGaodeMapNavigation');
  }
  return nativeModuleCache;
}

export default new Proxy({} as ExpoGaodeMapNavigationModuleType, {
  get(_target, prop) {
    return Reflect.get(getNativeModule() as object, prop);
  },
});
