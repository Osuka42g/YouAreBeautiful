import Kitura
import HeliumLogger
import SwiftyJSON
import KituraRequest

HeliumLogger.use()

let router = Router()
let cg = config()
let mm = messagesManager()
let vh = visionHandler()
let um = usersManager()

router.get("/") {
    request, response, next in
    response.send("You are beautiful :)")
    next()
}

router.all("/request", middleware: BodyParser())

router.get("/request") { request, response, _ in
    // Facebook authorization
    if let challenge = request.queryParameters["hub.challenge"] {
      try response.send("\(challenge)").end()
    } else {
      try response.send("Missing something?").end()
    }
}

// Our main method to get messages.
router.post("/request") { request, response, next in
    guard let parsedBody = request.body else {
        next()
        return
    }
    
    um.save();

    switch(parsedBody) {
      case .json(let jsonBody):
        print(jsonBody)
        let messageData = reqMessage(jsonBody)

          switch(messageData.type()) {
            case .text:
                let mes = "Send your image! 📸"
//                    mm.sendMessage(resMessage(messageData.sender_id(), messageData.sender_message(showInvalids: true)))
                mm.sendMessage(resMessage(messageData.sender_id(), mes))

            case .attachment:
                let resText = "Eh, buenaza imagen."
                mm.sendMessage(resMessage(messageData.sender_id(), resText, ofType: .typing))
                vh.testImage(image_url: messageData.attachment_url()!, respond_to: messageData.sender_id())


            case .callback: break
            case .other:
                print("Got a kind of \"weird\" message and I don't know what to do")
            break
            
          }

          try response.send("{\"result\": \"ok\"}").end()
      default:
          break
    }
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
