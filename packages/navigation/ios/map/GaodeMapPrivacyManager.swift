import AMapFoundationKit
import AMapLocationKit
import MAMapKit

enum GaodeMapPrivacyManager {
    private(set) static var hasShow = false
    private(set) static var hasContainsPrivacy = false
    private(set) static var hasAgree = false

    static var isReady: Bool {
        hasShow && hasContainsPrivacy && hasAgree
    }

    static func setPrivacyShow(_ show: Bool, hasContainsPrivacy: Bool) {
        hasShow = show
        self.hasContainsPrivacy = hasContainsPrivacy
        applyPrivacyState()
    }

    static func setPrivacyAgree(_ agree: Bool) {
        hasAgree = agree
        applyPrivacyState()
    }

    static func applyPrivacyState() {
        let showStatus: AMapPrivacyShowStatus = hasShow ? .didShow : .notShow
        let infoStatus: AMapPrivacyInfoStatus = hasContainsPrivacy ? .didContain : .notContain
        let agreeStatus: AMapPrivacyAgreeStatus = hasAgree ? .didAgree : .notAgree

        MAMapView.updatePrivacyShow(showStatus, privacyInfo: infoStatus)
        MAMapView.updatePrivacyAgree(agreeStatus)
        AMapLocationManager.updatePrivacyShow(showStatus, privacyInfo: infoStatus)
        AMapLocationManager.updatePrivacyAgree(agreeStatus)
    }

    static func status() -> [String: Bool] {
        [
            "hasShow": hasShow,
            "hasContainsPrivacy": hasContainsPrivacy,
            "hasAgree": hasAgree,
            "isReady": isReady,
        ]
    }
}
