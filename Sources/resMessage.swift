import Foundation
import SwiftyJSON

public class resMessage {
  public var message = ""
  public var recipient = ""
  public enum type {
    case standard
    case attachment
    case button
  }

	init(_ recipient_id: String, _ message_text: String, type: type = .standard) {
    message = message_text
    recipient = recipient_id
	}

  public func out() -> [String: Any] {
    return [ "message": ["text": message], "recipient": ["id": recipient] ]
  }

}
