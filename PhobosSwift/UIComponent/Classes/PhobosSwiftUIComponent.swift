//
//
//  PhobosSwiftUIComponent.swift
//  PhobosSwiftUIComponent
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

import AlamofireImage
import PhobosSwiftLog
import RxCocoa
import RxSwift

extension Bundle {
  static var bundle: Bundle {
    Bundle.pbs.bundle(with: PhobosSwiftUIComponent.self)
  }
}

extension String {
  var localized: String {
    pbs.localized(inBundle: Bundle.bundle)
  }
}

extension PBSLogger {
  static var logger = PBSLogger.shared
}

extension UIImage {
  internal static func image(named name: String) -> UIImage {
    let emptyImage = UIImage.pbs.makeImage(from: .clear)
    return UIImage(named: name, in: Bundle.bundle, compatibleWith: nil) ?? emptyImage
  }
}

extension Reactive where Base: UIImageView {
  /// Bindable sink for `imageUrl` property.
  internal var imageUrl: Binder<URL?> {
    Binder(base) { imageView, url in
      if let url = url {
        imageView.af.setImage(withURL: url, placeholderImage: Resource.Image.kImageArticlePlaceHolder)
      } else {
        imageView.image = Resource.Image.kImageArticlePlaceHolder
      }
    }
  }
}

class PhobosSwiftUIComponent: NSObject {}
