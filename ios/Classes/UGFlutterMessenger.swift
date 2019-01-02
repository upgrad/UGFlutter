import Foundation
import Flutter

class UGFlutterMessenger {
    private var messageChannel: FlutterBasicMessageChannel
    private weak var delegate: UGFlutterMessageDelegate?

    init(name: String, engine: FlutterEngine, delegate: UGFlutterMessageDelegate?) {
        self.messageChannel = FlutterBasicMessageChannel(name: name, binaryMessenger: engine, codec: FlutterStringCodec.sharedInstance())
        self.delegate = delegate
        self.messageChannel.setMessageHandler(handleMessage(message:reply:))
    }

    func handleMessage(message: Any?, reply: FlutterReply) {
        self.delegate?.didReceiveMessage(message: message)
    }

    func sendMessage(message: String) {
        self.messageChannel.sendMessage(message)
    }
}