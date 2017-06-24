import Foundation
import SwiftyJSON

class personsDictionary {
  public var users = [userProfile]()

	init() {

	}

  func append(_ user: userProfile) {
    users.append(user)
  }

  func check_id(_ id: String) -> Bool {
      return false
  }

}
