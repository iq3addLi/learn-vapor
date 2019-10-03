//
//  Payload.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//

import JWT

struct Payload{
    let username: String
}

extension Payload: JWTPayload{
    func verify(using signer: JWTSigner) throws {
        // nothing to verify
    }
}
