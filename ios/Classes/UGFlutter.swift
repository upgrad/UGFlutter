import Foundation
import Flutter

public class UGFlutter {
    private static let reloadChannelName: String = "reload"
    private static let defaultFlutterEngineIdentifier: String = "io.flutter"
    private static let setInitialRouteMethod: String = "setInitialRoute"
    private static var flutterEngine: FlutterEngine!
    private static var flutterMessengersDict: [String: UGFlutterMessenger] = [:]

    public static func configure() {
        self.flutterEngine = FlutterEngine(name: self.defaultFlutterEngineIdentifier, project: nil)
        self.flutterEngine.run(withEntrypoint: nil)
        self.createReloadMesseger()
    }

    public static func createMessenger(name: String, delegate: UGFlutterMessageDelegate?) {
        guard name != self.reloadChannelName else {
            fatalError("Cannot create channel with name reload. Duplicate name error.")
        }
        self.flutterMessengersDict[name] = UGFlutterMessenger(name: name, engine: self.flutterEngine, delegate: delegate)
    }

    private static func createReloadMesseger() {
        self.flutterMessengersDict[self.reloadChannelName] = UGFlutterMessenger(name: self.reloadChannelName, engine: self.flutterEngine, delegate: nil)
    }

    public static func sendMessage(channelName: String, message: String) {
        guard let flutterMessenger = self.flutterMessengersDict[channelName] else {
            fatalError("No channel with the name found.")
        }

        flutterMessenger.sendMessage(message: message)
    }

    public class func push(initialRoute: String, onNavigationController nvc: UINavigationController, animated: Bool) {
        self.flutterEngine.navigationChannel.invokeMethod(self.setInitialRouteMethod, arguments: initialRoute)
        self.flutterMessengersDict[self.reloadChannelName]!.sendMessage(message: initialRoute)
        guard let vc = FlutterViewController(engine: self.flutterEngine, nibName: nil, bundle: nil) else {
            return
        }
        vc.splashScreenView = nil
        nvc.pushViewController(vc, animated: animated)
    }

    public class func present(initialRoute: String,
                           onViewController presentingVC: UIViewController, animated: Bool, completion: (() -> ())?) {
        self.flutterEngine.navigationChannel.invokeMethod(self.setInitialRouteMethod, arguments: initialRoute)
        self.flutterMessengersDict[self.reloadChannelName]!.sendMessage(message: initialRoute)
        guard let vc = FlutterViewController(engine: self.flutterEngine, nibName: nil, bundle: nil) else {
            return
        }
        vc.setInitialRoute(initialRoute)
        vc.splashScreenView = nil
        presentingVC.present(vc, animated: animated, completion: completion)
    }
}