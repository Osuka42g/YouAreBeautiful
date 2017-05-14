import Foundation
import SwiftyJSON

class reqMessage {
  public var message_sender_id = ""
  public var message_sender_text = ""
  public var message_sender_attachment = ""

	init(_ jsonData: JSON) {
    message_sender_id = jsonData["entry"][0]["messaging"][0]["sender"]["id"].string!
    message_sender_text = jsonData["entry"][0]["messaging"][0]["message"]["text"].string ?? ""
    message_sender_attachment = jsonData["entry"][0]["messaging"][0]["message"]["attachments"][0]["payload"]["url"].string ?? ""
	}

  func sender_id() -> String {
      return message_sender_id
  }

  func sender_message(_ showInvalids: Bool = false) -> String {
      if showInvalids == true && message_sender_text == "" {
          return "Invalid"
      } else {
          return message_sender_text
      }
  }

  func health() -> String {

    return "ok"
  }
}
