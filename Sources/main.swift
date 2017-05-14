import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest

// Initialize HeliumLogger
HeliumLogger.use()

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.all("/request", middleware: BodyParser())

router.get("/request") { request, response, _ in
    if let challenge = request.queryParameters["hub.challenge"] {
      try response.send("\(challenge)").end()
    } else {
      try response.send("Missing something?").end()
    }
}

router.post("/request") { request, response, next in
    guard let parsedBody = request.body else {
        next()
        return
    }

    switch(parsedBody) {
      case .json(let jsonBody):
              let messageData = reqMessage(jsonBody)
              let cg = config()
              let message = [ "message": ["text": messageData.sender_message()], "recipient": ["id": messageData.sender_id()] ]
              KituraRequest.request(.post,
                      cg.facebook_endpoint(),
                      parameters: message,
                      encoding: JSONEncoding.default)
              try response.send("{\"result\": \"ok\"}").end()
      default:
          break
    }
    next()
}



// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
