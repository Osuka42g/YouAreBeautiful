import Foundation
import SwiftyJSON

class reqMessage {

  public enum message_types {
    case text
    case attachment
    case callback
    case other
  }

  public var message_sender_id = ""
  public var message_sender_text = ""
  public var message_sender_attachment = ""
  public var message_type = message_types.other

	init(_ jsonData: JSON) {
    message_sender_id = jsonData["entry"][0]["messaging"][0]["sender"]["id"].string!
    if let mst = jsonData["entry"][0]["messaging"][0]["message"]["text"].string {
      message_sender_text = mst
      message_type = .text
    }
    if let msa = jsonData["entry"][0]["messaging"][0]["message"]["attachments"][0]["payload"]["url"].string {
      message_sender_attachment = msa
      message_type = .attachment
    }
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

  func attachment_url() -> String {
    return message_sender_attachment
}

  func type() -> message_types {
    return message_type
  }

  func health() -> String {

    return "ok"
  }
}
