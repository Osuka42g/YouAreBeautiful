import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest

HeliumLogger.use()

let router = Router()

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

router.all("/static", middleware: StaticFileServer(path: "./static"))

router.post("/request") { request, response, next in
    guard let parsedBody = request.body else {
        next()
        return
    }

    switch(parsedBody) {
      case .json(let jsonBody):
              print(jsonBody)
              let messageData = reqMessage(jsonBody)
              let cg = config()
              let mm = messagesManager()
              let vh = visionHandler()

              switch(messageData.type()) {
                case .text:
                  mm.sendMessage(resMessage(messageData.sender_id(), messageData.sender_message(true)))

                case .attachment:
                  let resText = "Eh, buenaza imagen."
                  mm.sendMessage(resMessage(messageData.sender_id(), resText))
                  vh.testImage(image_url: messageData.attachment_url())


                case .callback: break
                case .other: break
                
              }

              try response.send("{\"result\": \"ok\"}").end()
      default:
          break
    }
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
