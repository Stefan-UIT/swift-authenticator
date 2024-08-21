//
//  RemoteConfigManager.swift
//  Authenticator
//
//  Created by Trung Vo on 21/08/2024.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    var isInReview: Bool {
        return inReviewVersion.versionCompare(MetaData.appVersion) == .orderedSame
    }
    
    var admobConfigs: AdmobConfigs {
        return AdmobConfigs(
            enabled: admobEnabled,
            adIds: [
                AdmobUnitType.rewarded: self.admobRewardedIds,
                AdmobUnitType.interstitial: self.admobInterstitialIds,
            ],
            highPriorityAdIds: [
                AdmobUnitType.interstitial: self.highValueAdmobInterstitialIds,
                AdmobUnitType.rewarded: self.highValueAdmobRewardedIds,
            ],
            umpConsentStatus: UMPConsentStatus.unknown,
            attStatus: ATTrackingManager.AuthorizationStatus.notDetermined
        )
    }
    
    // 90mins button in Home Screen
    var is90MinsButtonInterstitialAd: Bool {
        return remoteConfig.configValue(forKey: Keys.is90MinsButtonInterstitialAd).boolValue
    }
    
    // +90mins button in Remain Connect Time Popup
    var isRemainingTimeInterstitialAd: Bool {
        return remoteConfig.configValue(forKey: Keys.isRemainingTimeInterstitialAd).boolValue
    }
    
    // Start VPN Inter or Reward ad
    var isStartVpnInterstitialAd: Bool {
        return remoteConfig.configValue(forKey: Keys.isStartVpnInterstitialAd).boolValue
    }
    
    var isToolsAdsEnabled: Bool {
        return remoteConfig.configValue(forKey: Keys.isToolsAdsEnabled).boolValue
    }
    
    var smartConnectUsesPremium: Bool {
        return remoteConfig.configValue(forKey: Keys.smartConnectUsesPremium).boolValue
    }
    
    var smartConnectCountryCodes: [String] {
        let rawValue = remoteConfig.configValue(forKey: Keys.smartConnectCountryCodes).stringValue ?? ""
        let countryCodes = rawValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return Array(Set(countryCodes))
    }
    
    private init() {
        loadDefaultValues()
    }
    
    func fetchCloudValues(completed: @escaping() -> ()) {
        activateDebugMode()
        remoteConfig.fetch { [weak self] status, error in
            guard let _self = self else {return}
            if status == .success {
                _self.remoteConfig.activate { _, _ in
                    logger.info(_self, "Retrieved values from the cloud!")
                }
                completed()
            }
            
            if let error = error {
                completed()
                logger.info(_self, "Uh-oh. Got an error fetching remote values \(error)")
                return
            }
        }
    }
}

extension RemoteConfigManager {
    enum Keys {
        static let inReview = "in_review"
        static let admobEnabled = "admob_enabled"
        static let admobInterstitialIds = "admob_interstitial_ids"
        static let admobRewardedIds = "admob_rewarded_ids"
        static let smartConnectUsesPremium = "smart_connect_uses_premium"
        static let smartConnectCountryCodes = "smart_connect_country_codes"
        static let is90MinsButtonInterstitialAd = "is_90mins_button_interstitial_ad"
        static let isRemainingTimeInterstitialAd = "is_remaining_time_interstitial_ad"
        static let admobInterstitialHighValueIds = "admob_interstitial_high_value_ids"
        static let admobRewardedHighValueIds = "admob_rewarded_high_value_ids"
        static let isStartVpnInterstitialAd = "is_start_vpn_interstitial_ad"
        static let isToolsAdsEnabled = "is_tools_ads_enabled"
    }
}

private extension RemoteConfigManager {
    private var inReviewVersion: String {
        return remoteConfig.configValue(forKey: Keys.inReview).stringValue ?? "1.0.0"
    }
    
    private var admobEnabled: Bool {
        return remoteConfig.configValue(forKey: Keys.admobEnabled).boolValue
    }
    
    private var highValueAdmobInterstitialIds: [String] {
        let rawValue = remoteConfig.configValue(forKey: Keys.admobInterstitialHighValueIds).stringValue ?? ""
        let unitIds = rawValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return unitIds
    }
    
    private var highValueAdmobRewardedIds: [String] {
        let rawValue = remoteConfig.configValue(forKey: Keys.admobRewardedHighValueIds).stringValue ?? ""
        let unitIds = rawValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return unitIds
    }
    
    private var admobInterstitialIds: [String] {
        let rawValue = remoteConfig.configValue(forKey: Keys.admobInterstitialIds).stringValue ?? ""
        let unitIds = rawValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
//        return Array(Set(unitIds))
        return unitIds
    }
    
    private var admobRewardedIds: [String] {
        let rawValue = remoteConfig.configValue(forKey: Keys.admobRewardedIds).stringValue ?? ""
        let unitIds = rawValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        return Array(Set(unitIds))
    }
    
    private func loadDefaultValues() {
        let defaults: [String: Any?] = [
            Keys.inReview : "1.0.0",
            Keys.admobEnabled: false,
            Keys.admobInterstitialIds : [],
            Keys.admobInterstitialHighValueIds: [],
            Keys.admobRewardedHighValueIds: [],
            Keys.admobRewardedIds: [],
            Keys.smartConnectUsesPremium: true,
            Keys.smartConnectCountryCodes: ["US"],
            Keys.isStartVpnInterstitialAd: true,
            Keys.isToolsAdsEnabled: true
        ]
        remoteConfig.setDefaults(defaults as? [String: NSObject])
    }
    
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
}

