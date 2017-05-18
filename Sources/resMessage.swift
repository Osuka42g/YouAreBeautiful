import Foundation
import SwiftyJSON

public class resMessage {
    public var message = ""
    public var recipient = ""
    public var type = message_types.standard
    
    public enum message_types {
        case standard
        case attachment
        case button
        case typing
    }

    init(_ recipient_id: String, _ message_text: String = "", ofType: message_types = .standard) {
        message = message_text
        recipient = recipient_id
        type = ofType
	}

    public func out() -> [String: Any] {
        switch type {
        case .standard:
            return [ "message": ["text": message], "recipient": ["id": recipient] ]
            break;
        case .typing:
            return [ "recipient": ["id": recipient], "sender_action": "typing_on" ]
            break;
        default:
            return [ "message": ["text": message], "recipient": ["id": recipient] ]
        }
    }

}
