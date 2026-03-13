import AMapFoundationKit
import AMapLocationKit
import MAMapKit

extension Notification.Name {
    static let gaodeMapPrivacyStatusDidChange = Notification.Name("ExpoGaodeMapPrivacyStatusDidChange")
}

enum GaodeMapPrivacyManager {
    private(set) static var hasShow = false
    private(set) static var hasContainsPrivacy = false
    private(set) static var hasAgree = false

    static var isReady: Bool {
        hasShow && hasContainsPrivacy && hasAgree
    }

    static func setPrivacyShow(_ show: Bool, hasContainsPrivacy: Bool) {
        let previousStatus = status()
        hasShow = show
        self.hasContainsPrivacy = hasContainsPrivacy
        applyPrivacyState()
        notifyIfNeeded(previousStatus: previousStatus)
    }

    static func setPrivacyAgree(_ agree: Bool) {
        let previousStatus = status()
        hasAgree = agree
        applyPrivacyState()
        notifyIfNeeded(previousStatus: previousStatus)
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

    private static func notifyIfNeeded(previousStatus: [String: Bool]) {
        let currentStatus = status()
        guard NSDictionary(dictionary: previousStatus).isEqual(to: currentStatus) == false else {
            return
        }

        NotificationCenter.default.post(
            name: .gaodeMapPrivacyStatusDidChange,
            object: nil,
            userInfo: currentStatus
        )
    }
}
