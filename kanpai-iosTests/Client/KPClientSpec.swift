//
//  KPClientSpec.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import Quick
import Nimble

class KPClientSpec: QuickSpec {
    override func spec() {
        describe("a client") {
            describe("# init()") {
                it("should be initialized") {
                    let URL    = NSURL(string: "http://example.com")
                    let client = KPClient(baseURL: URL!)
                    
                    expect(client).notTo(beNil())
                }
            }
        }
    }
}