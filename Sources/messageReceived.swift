import Foundation
import SwiftyJSON

public class messageReceived {

    public enum message_types {
        case text
        case attachment
        case callback
        case other
    }

    public var message_sender_id: String?
    public var message_sender_text: String?
    public var message_sender_attachment: String?
    public var message_type = message_types.other

    
    // Setup all Object from JSON Data
    init(_ jsonData: JSON) {
        message_sender_id = jsonData["entry"][0]["messaging"][0]["sender"]["id"].string!
        
        // Verify if is a Text message
        if let mst = jsonData["entry"][0]["messaging"][0]["message"]["text"].string {
            message_sender_text = mst
            message_type = .text
        }
    
        // Verify if is an Attachment message
        if let msa = jsonData["entry"][0]["messaging"][0]["message"]["attachments"][0]["payload"]["url"].string {
            message_sender_attachment = msa
            message_type = .attachment
        }
	}

    
    ////////////////////
    // Object Methods //
    ////////////////////
    
    // Retrieves the Facebook ID of the remitent
    func sender_id() -> String {
        return message_sender_id!
    }

    // Retrieves the message of the remitent
    func sender_message(showInvalids: Bool = false) -> String {
        return showInvalids && (message_sender_text != nil) ? "Invalid" : message_sender_text!
    }

    // Retrieves the url of the message, if sent any
    func attachment_url() -> String? {
        return message_sender_attachment
    }

    func type() -> message_types {
        return message_type
    }

    func health() -> String {
        return "ok"
    }
}
