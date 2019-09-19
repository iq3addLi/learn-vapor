//
//  Book.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Foundation

struct Book{
    let title: String
    let author: String
}

import Vapor

extension Book: Content{}
