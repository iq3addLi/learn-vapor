//
//  Payload.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//



final class Payload{
    var username: String
    var exp: ExpirationClaim
    
    init(username: String, exp: ExpirationClaim){
        self.username = username
        self.exp = exp
    }
}

import JWT
extension Payload: JWTPayload{
    
    // MEMO: signatureData verify already finished before here.
    // What we do here is to validate the Payload.
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
}

import Vapor
extension Payload: Service{} // MEMO: struct is can't be Service
