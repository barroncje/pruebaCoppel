//
//  LoginData.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation

struct RequestToken: Decodable {
    let success: Bool?
    let expires_at: String?
    let request_token: String?
    let status_code: Int?
    let status_message: String?
    let session_id: String?
}

