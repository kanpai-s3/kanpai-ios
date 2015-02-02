//
//  KPClientSpec.swift
//  kanpai-ios
//
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import Quick
import Nimble
import AeroGearHttpStub

class KPClientSpec: QuickSpec {
    override func spec() {
        
        let stubResponseWithStatusCode: (String, String?, Int) -> Void = { (path, responseFileName, statusCode) in
            let headers = ["Content-Type": "application/json"]
            
            StubsManager.stubRequestsPassingTest({ (req) -> Bool in
                return req.URL.path == path
            }, withStubResponse: { (req) -> StubResponse in
                if let fileName = responseFileName {
                    let bundle = NSBundle(forClass: self.classForCoder )
                    return StubResponse(filename: fileName, location: StubResponse.Location.Bundle(bundle), statusCode: statusCode, headers: headers)
                } else {
                    return StubResponse(data: NSData(), statusCode: statusCode, headers: headers)
                }
            })
        }
        
        let stubResponse: (String, String?) -> Void = { (path, responseFileName) in
            stubResponseWithStatusCode(path, responseFileName, 200)
        }
        
        describe("a client") {
            describe("# init()") {
                it("should be initialized") {
                    let client = KPClient(baseURL: "http://example.com")
                    
                    expect(client).notTo(beNil())
                }
            }
            
            describe("# postParty()", {
                let client = KPClient(baseURL: "http://example.com")
                
                it("should success to submit and return party contained id") {
                    stubResponse("/parties", "success_to_post_party.json")
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        client.postParty(party) { (error, pt) in
                            expect(error).to(beNil())
                            expect(pt).notTo(beNil())
                            expect(pt).to(equal(party))
                            expect(pt.id).notTo(beNil())
                            expect(pt.id).to(equal("e6d27432-a924-11e4-89d3-123b93f75cba"))
                            done()
                        }
                    }
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        party.location = "yokohama"
                        client.postParty(party) { (error, pt) in
                            expect(error).to(beNil())
                            expect(pt).notTo(beNil())
                            expect(pt).to(equal(party))
                            expect(pt.id).notTo(beNil())
                            expect(pt.id).to(equal("e6d27432-a924-11e4-89d3-123b93f75cba"))
                            done()
                        }
                    }

                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        party.message = "hello"
                        client.postParty(party) { (error, pt) in
                            expect(error).to(beNil())
                            expect(pt).notTo(beNil())
                            expect(pt).to(equal(party))
                            expect(pt.id).notTo(beNil())
                            expect(pt.id).to(equal("e6d27432-a924-11e4-89d3-123b93f75cba"))
                            done()
                        }
                    }
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        party.location = "yokohama"
                        party.message = "hello"
                        client.postParty(party) { (error, pt) in
                            expect(error).to(beNil())
                            expect(pt).notTo(beNil())
                            expect(pt).to(equal(party))
                            expect(pt.id).notTo(beNil())
                            expect(pt.id).to(equal("e6d27432-a924-11e4-89d3-123b93f75cba"))
                            done()
                        }
                    }
                }
                
                it("should return error for invalid parameter") {
                    stubResponseWithStatusCode("/parties", "invalid_parameter.json", 400)
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        client.postParty(party) { (error, pt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("invalid parameter"))
                            done()
                        }
                    }
                }

                it("should return error for internal server error") {
                    stubResponseWithStatusCode("/parties", "internal_server_error.json", 500)
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        client.postParty(party) { (error, pt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("internal server error"))
                            done()
                        }
                    }
                }

                it("should return error for unkown error") {
                    stubResponseWithStatusCode("/parties", nil, 500)
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        client.postParty(party) { (error, pt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).to(beNil())
                            done()
                        }
                    }
                    
                    stubResponseWithStatusCode("/parties", nil, 200)
                    
                    waitUntil { done in
                        let party = KPParty(owner: "party", beginAt: NSDate())
                        client.postParty(party) { (error, pt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).to(beNil())
                            done()
                        }
                    }
                }
            })
            
            describe("# addGuest()", {
                let client = KPClient(baseURL: "http://example.com")
                let party  = KPParty(owner: "party", beginAt: NSDate())
                let guest = KPGuest(name: "noda", phoneNumber: "08099999999")
                
                beforeEach {
                    party.id = "e6d27432-a924-11e4-89d3-123b93f75cba"
                }
                
                it("should success to add guest to party and return guest contained id") {
                    stubResponse("/parties/\(party.id)/guests", "success_to_add_guest.json")
                    
                    waitUntil { done in
                        client.addGuest(guest, to: party) { (error, gt) in
                            expect(error).to(beNil())
                            expect(gt).notTo(beNil())
                            expect(gt).to(equal(guest))
                            expect(gt.id).notTo(beNil())
                            expect(gt.id).to(equal("f6bbbd24-a95e-11e4-89d3-123b93f75cba"))
                            done()
                        }
                    }
                }
                
                it("should throw fatal error becase party dosen't have id") {
                    party.id = ""
                    expect {
                        client.addGuest(guest, to: party) { (error, json) in
                        }
                    }.to(raiseException())
                }
                
                it("should return error for invalid parameter") {
                    stubResponseWithStatusCode("/parties/\(party.id)/guests", "invalid_parameter.json", 400)
                    
                    waitUntil { done in
                        client.addGuest(guest, to: party) { (error, gt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("invalid parameter"))
                            done()
                        }
                    }
                }
                
                it("should return error for internal server error") {
                    stubResponseWithStatusCode("/parties/\(party.id)/guests", "internal_server_error.json", 400)
                    
                    waitUntil { done in
                        client.addGuest(guest, to: party) { (error, gt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("internal server error"))
                            done()
                        }
                    }
                }
                
                it("should return error for unkown error") {
                    stubResponseWithStatusCode("/parties/\(party.id)/guests", nil, 500)
                    
                    waitUntil { done in
                        client.addGuest(guest, to: party) { (error, gt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).to(beNil())
                            done()
                        }
                    }

                    stubResponseWithStatusCode("/parties/\(party.id)/guests", nil, 200)
                    
                    waitUntil { done in
                        client.addGuest(guest, to: party) { (error, gt) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).to(beNil())
                            done()
                        }
                    }
                }
            })
            
            describe("# updateGuest()", {
                let client = KPClient(baseURL: "http://example.com")
                let guest = KPGuest(name: "noda", phoneNumber: "08099999999")
                
                beforeEach {
                    guest.id = "f6bbbd24-a95e-11e4-89d3-123b93f75cba"
                }
                
                it("should success to update guest") {
                    stubResponse("/guests/\(guest.id)", nil)
                    
                    waitUntil { done in
                        client.updateGuest(guest) { (error) in
                            expect(error).to(beNil())
                            done()
                        }
                    }
                }
                
                it("should throw fatal error becase guest dosen't have id") {
                    guest.id = ""
                    expect {
                        client.updateGuest(guest) { (error) in
                        }
                    }.to(raiseException())
                }
                
                it("should return error for invalid parameter") {
                    stubResponseWithStatusCode("/guests/\(guest.id)", "invalid_parameter.json", 400)
                    
                    waitUntil { done in
                        client.updateGuest(guest) { (error) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("invalid parameter"))
                            done()
                        }
                    }
                }
                
                it("should return error for internal server error") {
                    stubResponseWithStatusCode("/guests/\(guest.id)", "internal_server_error.json", 400)
                    
                    waitUntil { done in
                        client.updateGuest(guest) { (error) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).notTo(beNil())
                            expect(message).to(equal("internal server error"))
                            done()
                        }
                    }
                }
                
                it("should return error for unkown error") {
                    stubResponseWithStatusCode("/guests/\(guest.id)", nil, 400)
                    
                    waitUntil { done in
                        client.updateGuest(guest) { (error) in
                            expect(error).notTo(beNil())
                            expect(error!.domain).to(equal(KPClientErrorDomain))
                            let message = error!.userInfo?[NSLocalizedDescriptionKey] as? String
                            expect(message).to(beNil())
                            done()
                        }
                    }                    
                }
            })
        }
    }
}