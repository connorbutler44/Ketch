//
//  Message.swift
//  Ketch
//
//  Created by Connor Butler on 3/24/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    func chatPartnerID() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
}
