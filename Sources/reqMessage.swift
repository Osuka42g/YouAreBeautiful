import Foundation
import SwiftyJSON

class reqMessage {
    public var message_sender_id = ""
    public var message_sender_text = ""

	init(_ jsonData: JSON) {
    message_sender_id = jsonData["entry"][0]["messaging"][0]["sender"]["id"].string!
    message_sender_text = jsonData["entry"][0]["messaging"][0]["message"]["text"].string!
	}

  func sender_id() -> String {
      return message_sender_id
  }

  func sender_message() -> String {
      return message_sender_text
  }

}
