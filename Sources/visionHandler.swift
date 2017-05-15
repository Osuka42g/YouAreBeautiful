import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest
import swiftgd
import Dispatch
import Foundation

class visionHandler {

    let cg = config()
    let mm = messagesManager()
    
    public func testImage(image_url: String) {

        let url = URL(string: image_url)!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let imageData = data.base64EncodedString()
            self.fetchFromVision(imageData)
            
        })
        
        task.resume()
        
    }
    
    public func fetchFromVision(_ image_url: String) {
        KituraRequest.request(.post,
                      cg.google_endpoint(),
                      parameters: self.setRequest(image_url),
                      encoding: JSONEncoding.default).response {
                        request, response, data, error in
                        let jsonData = JSON(data: data!)
                        self.handleVisionResponse(jsonData)
            }
    

    }

    
    public func handleVisionResponse(_ visionResponse: JSON) {
        print(visionResponse)
        
//        let safeSearchResults = visionResponse["responses"][0]["safeSearchAnnotation"].string!
        
    }
    
    public func setRequest(_ image64data: String) -> [String: Any] {
      var request = [String: Any]()
      let features = [["type": "LABEL_DETECTION", "maxResults": "10"], ["type": "SAFE_SEARCH_DETECTION"], ["type": "WEB_DETECTION"]]
        request["requests"] = ["image": ["content":  image64data], "features": features]
    
      return request
    }
}
