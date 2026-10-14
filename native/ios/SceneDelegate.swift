import UIKit
import HotwireNative

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let navigator = Navigator(configuration: .init(
        name: "relay",
        startLocation: URL(string: "http://localhost:3000")!
    ))

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = navigator.rootViewController
        navigator.start()
    }
}
