import Foundation
import SwiftyJSON

public class resMessage {
    public var message: String?
    public var recipient: String?
    public var type = message_types.standard
    
    public enum message_types {
        case standard
        case attachment
        case button
        case typing
    }

    init(_ recipient_id: String, _ message_text: String?, ofType: message_types = .standard) {
        message = message_text
        recipient = recipient_id
        type = ofType
	}

    
    ////////////////////
    // Object Methods //
    ////////////////////
    
    // Returns an array with the structure ready to convert to JSON and to be sent to messenger
    public func out() -> [String: Any]? {
        if(!isSendable()) { return nil }
        switch type {
            case .standard:
                return [ "message": ["text": message], "recipient": ["id": recipient] ]
            case .typing:
                return [ "recipient": ["id": recipient], "sender_action": "typing_on" ]
            default:
                return [ "message": ["text": message], "recipient": ["id": recipient] ]
        }
    }
    
    public func isSendable() -> Bool {
        switch type {
        case .standard:
            if(recipient == nil && message == nil) {
                print("Recipient ID or message are missing for STANDARD response.")
                return false
            }
            break;
        case .typing:
            if(recipient == nil) {
                print("Recipient ID is missing for TYPING response.")
                return false
            }
            break;
        default:
            return true
        }
        return true
    }

}
