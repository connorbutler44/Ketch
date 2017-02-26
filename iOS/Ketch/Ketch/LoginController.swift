//
//  LoginController.swift
//  Ketch
//
//  Created by Patrick Carder on 2/26/17.
//  Copyright © 2017 butlerproject. All rights reserved.
//

import Foundation

import FacebookLogin

func viewDidLoad() {
    let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
    loginButton.center = view.center
    
    view.addSubview(loginButton)
}
