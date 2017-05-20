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
    var send_to = ""
    
    public func testImage(image_url: String, respond_to: String?) {

        if (respond_to != nil) { send_to = respond_to! }
        
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

    
    public func handleVisionResponse(_ response: JSON) {
        print(response)
        var responseError: String?
        let successMessage = "Aww yeah! You are ready to rock!"
        
        let hResponse = visionResponse(response)
        
        let safeSearchResults = response["responses"][0]["safeSearchAnnotation"]
        for safeResult in safeSearchResults {
            mm.sendMessage(resMessage(send_to, "Result \(safeResult.0) = \(safeResult.1.string!)"))
            
            switch safeResult.1.string! {
                case "POSSIBLE", "LIKELY", "VERY_LIKELY":
                    responseError = "Hey! This picture is a bit out of context... You might not want to send this 😨"
                break;
                default:
                
                break;
            }
        }
        
        if responseError == nil && hResponse.countWebDetectionResults() > 40 {
            responseError = "Why don't you try with something less popular 😉"
        }
        
        
        if (responseError != nil) {
            mm.sendMessage(resMessage(send_to, responseError!))
        } else {
            mm.sendMessage(resMessage(send_to, successMessage))
        }
    }
    
    public func setRequest(_ image64data: String) -> [String: Any] {
      var request = [String: Any]()
      let features = [["type": "LABEL_DETECTION", "maxResults": "10"], ["type": "SAFE_SEARCH_DETECTION"], ["type": "WEB_DETECTION"]]
        request["requests"] = ["image": ["content":  image64data], "features": features]
    
      return request
    }
}
