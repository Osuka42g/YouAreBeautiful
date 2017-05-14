import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest

public class messagesManager {

  public func sendMessage(_ message: resMessage) {
    let cg = config()

    KituraRequest.request(.post,
      cg.facebook_endpoint(),
      parameters: message.out(),
      encoding: JSONEncoding.default)
  }

}
