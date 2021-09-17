//
//
//  Bundle.swift
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

private let kBundle = "bundle"
private let kBundleURLTypes = "CFBundleURLTypes"
private let kBundleVersion = "CFBundleVersion"
private let kBundleShortVersionString = "CFBundleShortVersionString"
private let kBundleURLSchemes = "CFBundleURLSchemes"
private let kBundleTypeRole = "CFBundleTypeRole"
///
public enum BundleTypeRole: String {
  case editor = "Editor"
  case viewer = "Viewer"
  case none = "None"
}

extension Bundle: PhobosSwiftCompatible {}

/// Bundle URL Scheme
public struct PBSBundleURLScheme {
  ///
  public var name: String
  ///
  public var role: BundleTypeRole
}

extension PhobosSwift where Base: Bundle {
  /// The alias of AnyClass
  public typealias BundleClass = AnyClass

  /// 获取前私有Pods对应的Bundle的实例
  ///
  /// - parameter bundleClass: The URL.
  ///
  /// - returns: The `Bundle` of the BundleClass in pod framework.
  public static func bundle(with bundleClass: BundleClass) -> Bundle {
    let className = String(describing: bundleClass)
    let path = Bundle(for: bundleClass).path(forResource: className, ofType: kBundle) ?? ""
    return Bundle(path: path) ?? Bundle.main
  }

  /// 获取bundle Short Version
  public var bundleShortVersion: String? {
    if let info = base.infoDictionary {
      if let appVersion = info[kBundleShortVersionString] as? String {
        return appVersion
      }
    }

    return nil
  }

  /// 获取bundle Version
  public var bundleVersion: String? {
    if let info = base.infoDictionary {
      if let bundleVersion = info[kBundleVersion] as? String {
        return bundleVersion
      }
    }

    return nil
  }

  /// Get the current list of External URL Schemes
  ///
  public var externalURLSchemes: [PBSBundleURLScheme] {
    guard let urlTypes = base.infoDictionary?[kBundleURLTypes] as? [[String: Any]] else {
      return []
    }

    var result: [PBSBundleURLScheme] = []
    for urlTypeDictionary in urlTypes {
      guard let urlSchemeNames = urlTypeDictionary[kBundleURLSchemes] as? [String] else { continue }
      guard let externalURLSchemeNames = urlSchemeNames.first else { continue }
      guard let typeRole = urlTypeDictionary[kBundleTypeRole] as? String else { continue }

      let urlScheme = PBSBundleURLScheme(name: externalURLSchemeNames, role: BundleTypeRole(rawValue: typeRole) ?? .none)
      result.append(urlScheme)
    }

    return result
  }
}
