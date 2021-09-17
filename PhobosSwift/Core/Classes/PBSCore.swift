//
//
//  PBSCore.swift
//  PhobosSwiftCore
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

import Foundation

///
@objcMembers
public class PBSCore: NSObject {
  public static var infoPath = Constants.kPhobosServiceInfoPlist

  /// The singleton `PBSCore` instance.
  public static var shared = PBSCore()

  /// Whether current running in XCTest
  public static var isRunningTest: Bool {
    NSClassFromString(Constants.kXCTest) != nil
  }

  /// The `InternalBuildVersion` of previous installation
  public private(set) var previousInternalBuildVersion: PBSVersion

  /// The  `InternalBuildVersion` of latest installation
  public var currentInternalBuildVersion: PBSVersion {
    // 在获取当前安装时，InternalBuildVersion
    PBSVersion.makeVersion(from: serviceInfo.internalBuildVersion)
  }

  private let appDelegateSwizzler = PBSCoreAppDelegateSwizzler()

  /// Phobos-Service-Info Model
  public var serviceInfo: PhobosServiceInfo!

  override private init() {
    previousInternalBuildVersion = PBSVersion.makeVersion(from: UserDefaults.standard.string(forKey: Constants.kInternalBuildVersion))

    super.init()
    loadInfoPlist()
    appDelegateSwizzler.load(withDefaultCore: self)
  }

  deinit {
    appDelegateSwizzler.unload()
  }

  public func checkInternalVersion(internalBuildVersion: (_ isUpgraded: Bool, _ previousVersion: PBSVersion, _ currentVersion: PBSVersion) -> Void) {
    let isUpgraded = currentInternalBuildVersion > previousInternalBuildVersion
    internalBuildVersion(isUpgraded, previousInternalBuildVersion, currentInternalBuildVersion)
  }

  private func loadInfoPlist() {
    var bundle = Bundle.main
    if PBSCore.isRunningTest {
      bundle = Bundle.bundle
    }

    guard let infoPlistPath = bundle.url(forResource: Self.infoPath, withExtension: nil) else {
      fatalError("File `\(Self.infoPath)` in main bundle not exist, please add this file to Supporting Files")
    }

    guard let data = try? Data(contentsOf: infoPlistPath) else {
      fatalError("Data in `\(Self.infoPath)` loaded in error")
    }

    guard let serviceInfo: PhobosServiceInfo = data.pbs.model(decoderType: .propertyList) else {
      fatalError("Data in `\(Self.infoPath)` loaded in error")
    }

    self.serviceInfo = serviceInfo
  }
}
