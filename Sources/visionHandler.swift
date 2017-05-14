import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest
import swiftgd
import Dispatch
import Foundation

class visionHandler {

  public func testImage(image_url: String) {

    let cg = config()
    
    KituraRequest.request(.post,
      cg.google_endpoint(),
      parameters: self.setRequest(image_url),
      encoding: JSONEncoding.default).response {
        request, response, data, error in
            print("Aca va la data")
            let dataString =  String(data: data!, encoding: String.Encoding.utf8)
            print(dataString)
        }
    }

    public func handleVisionResponse(_ response: AnyObject) {
        print(response)
    }
    
    public func setRequest(_ imageUrl: String) -> [String: Any] {
      var request = [String: Any]()
      let features = [["type": "LABEL_DETECTION", "maxResults": "10"], ["type": "SAFE_SEARCH_DETECTION"], ["type": "WEB_DETECTION"]]
        request["requests"] = ["image": ["source": ["imageUri" : imageUrl]], "features": features]
    
      return request
    }
}
