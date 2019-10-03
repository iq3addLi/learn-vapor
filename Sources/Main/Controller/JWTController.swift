//
//  JWTController.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//

import Vapor
import JWT

struct JWTController{
    
    let secret: LosslessDataConvertible = "secret"

    
    // JWT Issue
    func getToken(_ request: Request) throws -> [ String: String ] {
        
        // Get parameter at query
        guard let username = request.query[ String.self, at: "username" ] else{
            throw Abort(.badRequest, reason: "The username is require in query.")
        }
        
        // create payload
        let payload = Payload(username: username)
        
        // create JWT and sign
        let data = try JWT(payload: payload).sign(using: .hs256(key: secret))
        return [ "token": String(data: data, encoding: .utf8) ?? "<encode failed>" ]
    }
    
    // JWT Verify (HTTP Body)
    func verifyToken(_ request: Request) throws -> Future<Response> {
        
        // JWT Verify (HTTP header bearer)
        if let bearer = request.http.headers.bearerAuthorization {
            // parse JWT from token string, using HS-256 signer
            let jwt = try JWT<Payload>(from: bearer.token, verifiedUsing: .hs256(key: self.secret))
            return request.response( GeneralInfomation("Your username is \(jwt.payload.username)") , as: .json).encode(status: .ok, for: request)
        }
        
        // JWT Verify (HTTP Body)
        // Get parameter at http body
        return try request.content.decode(json: PayloadRequest.self, using: JSONDecoder()).map { (payloadReq) in
            
            // parse JWT from token string, using HS-256 signer
            let jwt = try JWT<Payload>(from: payloadReq.token, verifiedUsing: .hs256(key: self.secret))
            return request.response( GeneralInfomation("Your username is \(jwt.payload.username)") , as: .json)
        }
    }
    
    
    
}
