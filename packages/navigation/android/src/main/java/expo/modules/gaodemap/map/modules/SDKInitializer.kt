package expo.modules.gaodemap.map.modules

import android.content.Context
import com.amap.api.location.AMapLocationClient
import com.amap.api.maps.MapsInitializer

/**
 * SDK 初始化管理器
 *
 * 负责:
 * - 初始化高德地图 SDK
 * - 初始化高德定位 SDK
 * - 设置隐私合规
 * - 获取 SDK 版本信息
 */
object SDKInitializer {
    private var privacyAgreed = false
    private var privacyShown = false
    private var privacyContains = false

    private fun resolveContext(context: Context): Context {
        return context.applicationContext ?: context
    }

    fun setPrivacyShow(context: Context, hasShow: Boolean, hasContainsPrivacy: Boolean) {
        privacyShown = hasShow
        privacyContains = hasContainsPrivacy
        applyPrivacyState(resolveContext(context))
    }

    fun setPrivacyAgree(context: Context, hasAgree: Boolean) {
        privacyAgreed = hasAgree
        applyPrivacyState(resolveContext(context))
    }

    fun applyPrivacyState(context: Context) {
        val appContext = resolveContext(context)
        try {
            MapsInitializer.updatePrivacyShow(appContext, privacyShown, privacyContains)
            AMapLocationClient.updatePrivacyShow(appContext, privacyShown, privacyContains)
            MapsInitializer.updatePrivacyAgree(appContext, privacyAgreed)
            AMapLocationClient.updatePrivacyAgree(appContext, privacyAgreed)
        } catch (e: Exception) {
            android.util.Log.w("ExpoGaodeMap", "同步隐私状态失败: ${e.message}")
        }
    }

    fun isPrivacyReady(): Boolean {
        return privacyShown && privacyContains && privacyAgreed
    }

    fun getPrivacyStatus(): Map<String, Boolean> {
        return mapOf(
            "hasShow" to privacyShown,
            "hasContainsPrivacy" to privacyContains,
            "hasAgree" to privacyAgreed,
            "isReady" to isPrivacyReady()
        )
    }

    /**
     * 初始化高德地图和定位 SDK
     *
     * @param context 应用上下文
     * @param androidKey Android 平台的 API Key
     * @throws Exception 初始化失败时抛出异常
     */
    fun initSDK(context: Context, androidKey: String) {
        val appContext = resolveContext(context)
        // 检查隐私协议状态
        if (!isPrivacyReady()) {
            throw expo.modules.kotlin.exception.CodedException("隐私协议未完成确认，请先调用 setPrivacyShow/setPrivacyAgree")
        }
        
        try {
            applyPrivacyState(appContext)
            // 设置 API Key
            MapsInitializer.setApiKey(androidKey)
            AMapLocationClient.setApiKey(androidKey)
            

        } catch (e: Exception) {
            throw Exception("SDK 初始化失败: ${e.message}")
        }
    }

    /**
     * 获取 SDK 版本号
     *
     * @return SDK 版本字符串
     */
    fun getVersion(): String {
        return MapsInitializer.getVersion()
    }
}
