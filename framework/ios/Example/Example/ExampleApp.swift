import OpenpathMobile
import SwiftUI

@main
struct ExampleApp: App {
    @StateObject private var loginViewModel = LoginViewModel()

    init() {
        #if FEATURE_FLAG_LOG_BLE_OVER_UDP
        if let host = ProcessInfo.processInfo.environment["UDP_HOST"],
           let portString = ProcessInfo.processInfo.environment["UDP_PORT"],
           let port = UInt16(portString) {
            UdpClient.shared.connect(host: host, port: port)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .onAppear {
                    OpenpathWrapper.shared.requestUnrequestedPermissions()
                }
        }
    }
}
