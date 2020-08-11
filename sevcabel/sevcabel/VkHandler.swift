//
//  VkHandler.swift
//  sevcabel
//
//  Created by Никита Бабенко on 10/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import Foundation
import SwiftyVK
import Firebase
import FirebaseDatabase

class VkHandler: SwiftyVKDelegate {
    
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    let scopes: Scopes = [.photos,.email]
    let VK_APP_ID = "6746743"
    var sessionId: String? 
    
    init() {
        VK.setUp(appId: VK_APP_ID, delegate: self)
        ref = Database.database().reference()
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return self.scopes
    }
    
    func logIn(onSuccess: @escaping () -> Void,
               onError: @escaping (_ e: Error) -> Void) {
        getSession()
        if(self.sessionId == nil) {
            VK.sessions.default.logIn(
                onSuccess: { _ in
                    onSuccess()
            },
                onError: { error in
                    onError(error)
            })
        }
        else {
            do {
                try VK.sessions.default.logIn(rawToken: sessionId!, expires: 0.0)
                onSuccess()
            } catch {
                onError(error)
            }
        }
    }
    
    func logOut() {
        VK.sessions.default.logOut()
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        self.ref.child("vk_token").setValue(sessionId)
        self.sessionId = sessionId
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        self.ref.child("vk_token").setValue(sessionId)
        self.sessionId = sessionId
    }
    
    func vkTokenRemoved(for sessionId: String) {
        self.ref.child("vk_token").setValue("")
        self.sessionId = nil
    }
    
    func getSession(){
        databaseHandle = ref.child("vk_token").observe(.value, with: { (snapshot) in
            self.sessionId = snapshot.value as? String
        })
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }
}
