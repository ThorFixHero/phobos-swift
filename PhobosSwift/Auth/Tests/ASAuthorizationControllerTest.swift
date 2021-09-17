//
//
//  ASAuthorizationControllerTest.swift
//  PhobosSwiftAuth-Unit-Tests
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import PhobosSwiftAuth
import AuthenticationServices
import Nimble
import Quick

class ASAuthorizationControllerTest: QuickSpec {
  override func spec() {
    testCrashs()
  }

  func testCrashs() {
    describe("Given ASAuthorizationController初始化") {
      if #available(iOS 13.0, *) {
        let controller = getASAuthorizationController()
        context("When 调用.didCompleteWithAuthorization") {
          _ = controller.rx.didCompleteWithAuthorization
          _ = controller.rx.didCompleteWithError
          it("Then 不会闪退") {
            expect(true).to(beTrue())
          }
        }
      } else {
        // Fallback on earlier versions
      }
    }
  }

  @available(iOS 13.0, *)
  func getASAuthorizationController() -> ASAuthorizationController {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])

    return controller
  }
}
