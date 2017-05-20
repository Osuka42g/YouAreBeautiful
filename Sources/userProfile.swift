import Foundation
import SwiftyJSON

class personUser {
    
    public var user_id = ""
    public var user_current_status = ""
    public var user_current_pic = ""
    public var language: String?

	init(_ userId: String) {
        user_id = userId
	}

    func userid() -> String {
        return user_id
    }

    func sender_message() -> String {
        return user_id
    }
}
