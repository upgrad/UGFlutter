import Foundation

public protocol UGFlutterMessageDelegate: class {
    func didReceiveMessage(message: Any?)
}