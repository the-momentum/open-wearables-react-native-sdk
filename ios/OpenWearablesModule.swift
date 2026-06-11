import ExpoModulesCore
import OpenWearablesHealthSDK

public class OpenWearablesModule: Module {
    public func definition() -> ModuleDefinition {
        Name("OpenWearablesHealthSDK")
        
        // MARK: - Callbacks (Events)        
        Events("onLog", "onAuthError")
        
        // MARK: - Lifecycle        
        OnCreate {
            OpenWearablesHealthSDK.shared.onLog = { message in
                self.sendEvent("onLog", [
                    "message": message
                ])
            }
            
            OpenWearablesHealthSDK.shared.onAuthError = { statusCode, message in
                self.sendEvent("onAuthError", [
                    "statusCode": statusCode,
                    "message": message
                ])
            }
        }
        
        // MARK: - Configure        
        Function("configure") { (host: String, customSyncURL: String?) in
            OpenWearablesHealthSDK.shared.configure(host: host)
        }
        
        // MARK: - Auth        
        AsyncFunction("signIn") { (
            userId: String,
            accessToken: String?,
            refreshToken: String?,
            apiKey: String?,
            promise: Promise
        ) in
            OpenWearablesHealthSDK.shared.signIn(
                userId: userId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                apiKey: apiKey
            )
            promise.resolve()
        }
        
        AsyncFunction("signOut") { (promise: Promise) in
            OpenWearablesHealthSDK.shared.signOut()
            promise.resolve()
        }
        
        Function("updateTokens") { (accessToken: String, refreshToken: String) in
            OpenWearablesHealthSDK.shared.updateTokens(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        }
        
        Function("restoreSession") {
            return OpenWearablesHealthSDK.shared.restoreSession()
        }
        
        Function("isSessionValid") {
            return OpenWearablesHealthSDK.shared.isSessionValid
        }
        
        // MARK: - HealthKit Authorization        
        AsyncFunction("requestAuthorization") { (types: [String], promise: Promise) in
            let healthTypes = types.compactMap { HealthDataType(rawValue: $0) }
            OpenWearablesHealthSDK.shared.requestAuthorization(types: healthTypes) { success in
                promise.resolve(success)
            }
        }
        
        // MARK: - Sync    
        Function("setSyncInterval") { (minutes: Double) in } // (not implemented in iOS SDK)
            
        AsyncFunction("startBackgroundSync") { (syncDaysBack: Int?, promise: Promise) in
            OpenWearablesHealthSDK.shared.startBackgroundSync(syncDaysBack: syncDaysBack) { started in
                promise.resolve(started)
            }
        }
        
        AsyncFunction("stopBackgroundSync") { (promise: Promise) in
            OpenWearablesHealthSDK.shared.stopBackgroundSync()
            promise.resolve()
        }
        
        AsyncFunction("syncNow") { (promise: Promise) in
            OpenWearablesHealthSDK.shared.syncNow {
                promise.resolve()
            }
        }
        
        AsyncFunction("resumeSync") { (promise: Promise) in
            OpenWearablesHealthSDK.shared.resumeSync { resumed in
                promise.resolve(resumed)
            }
        }
        
        Function("isSyncActive") {
            return OpenWearablesHealthSDK.shared.isSyncActive
        }
        
        Function("getSyncStatus") {
            return OpenWearablesHealthSDK.shared.getSyncStatus()
        }
        
        Function("resetAnchors") {
            OpenWearablesHealthSDK.shared.resetAnchors()
        }
        
        Function("getStoredCredentials") {
            return OpenWearablesHealthSDK.shared.getStoredCredentials()
        }

        // MARK: - Providers (not implemented in iOS SDK)        
        Function("getAvailableProviders") { return [] }
        
        Function("setProvider") { }

        // MARK: - Logs
        Function("setLogLevel") { (levelId: Int) in
            let level = OWLogLevel(rawValue: levelId) ?? .debug
            OpenWearablesHealthSDK.shared.setLogLevel(level)
        }

        Function("getLogLevel") {
            return OpenWearablesHealthSDK.shared.logLevel.rawValue
        }
    }
}