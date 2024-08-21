//
//  BiometricAuthenticationService.swift
//  Authenticator
//
//  Created by Trung Vo on 8/20/24.
//

import Foundation
import UIKit
import LocalAuthentication

let IS_APP_LOCKED = "BiometricAuthenticationService.isAppLocked"

class BiometricAuthenticationService: NSObject {
    static let shared = BiometricAuthenticationService()
    var isFaceId: Bool = false
    var iconImageString: String {
        get {
            biometricsType == .faceID ? "faceid" : "touchid"
        }
    }
    var securityTitle: String {
        get {
            return "Lock with " + biometricsName
        }
    }
    var unlockTitle: String {
        get {
            return "Unlock with " + biometricsName
        }
    }
    
    var isAppLocked: Bool {
        var result = false
        if let value = UserDefaults.standard.value(forKey: IS_APP_LOCKED) as? Bool {
            result = value
        }
        return result
    }
    
    func setAppLocked(isEnable: Bool) {
        UserDefaults.standard.setValue(isEnable, forKey: IS_APP_LOCKED)
    }
    
    fileprivate let biometricsType: LABiometryType = {
        let laContext = LAContext()
        var error: NSError?
        let evaluated = laContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)

        if let laError = error {
            print("laError - \(laError)")
            return .none
        }

        if #available(iOS 11.0, *) {
            if laContext.biometryType == .faceID { return .faceID }
            if laContext.biometryType == .touchID { return .touchID }
        } else {
            if (evaluated || (error?.code != LAError.touchIDNotAvailable.rawValue)) {
                return .touchID
            }
        }
        return .none
    }()
    
    func authenticateWithBiometrics(completion: @escaping (Bool,String?)->()) {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            let reason = "Authenticate to lock your document"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        completion(true, nil)
                    } else {
                        // Authentication failed
                        let mess = "Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")"
                        completion(false, self.generalErrorMessage)
                    }
                }
            }
        } else {
            // Biometric authentication is not available or an error occurred
            completion(false, generalErrorMessage)
        }
    }
    
    private var generalErrorMessage: String {
        "\(biometricsName) Authentication Failed. Please try again!"
    }
    
    private var biometricsName: String {
        biometricsType == .touchID ? "Touch ID" : "Face ID"
    }
}


