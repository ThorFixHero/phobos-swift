//
//
//  PBSArticleBigCardECell.swift
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

import PhobosSwiftCore
import RxCocoa
import RxSwift
import SnapKit
import UIKit

let kSpacing: CGFloat = 18.0

///
class PBSArticleBigCardECell: PBSArticleBigCardCell {
  class var coverImageSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 256

    return CGSize(width: width, height: height)
  }

  class var itemSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - kSpacing * 2.0
    let height: CGFloat = width / 339.0 * 436

    return CGSize(width: width, height: height)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    style = .brown

    makeSubviews()
    makeStyles()
  }

  func makeSubviews() {
    mainView.snp.makeConstraints {
      $0.left.right.top.bottom.equalTo(0)
    }

    coverImageView.snp.makeConstraints {
      $0.top.left.right.equalTo(0.0)
      $0.height.equalTo(Self.coverImageSize.height)
      $0.bottom.equalTo(tagLabel.snp.top).offset(-8)
    }

    tagLabel.snp.makeConstraints {
      $0.top.equalTo(coverImageView.snp.bottom).offset(8)
      $0.left.equalTo(kSpacing)
      $0.right.equalTo(-kSpacing)
      $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(kSpacing)
      $0.right.equalTo(-kSpacing)
      $0.bottom.equalTo(subtitleLabel.snp.top).offset(-8)
    }

    subtitleLabel.snp.makeConstraints {
      $0.left.equalTo(kSpacing)
      $0.right.equalTo(-kSpacing)
      $0.bottom.lessThanOrEqualToSuperview()
    }

    actionBtn.snp.makeConstraints {
      $0.left.equalTo(kSpacing)
      $0.top.greaterThanOrEqualTo(subtitleLabel.snp.bottom)
      $0.bottom.lessThanOrEqualTo(0)
      $0.height.equalTo(55)
    }
  }

  func makeStyles() {
    mainView.frame = CGRect(origin: .zero, size: Self.itemSize)
    mainView.layer.cornerRadius = 8.0
    mainView.pbs.addShadow(radius: 8.0)

    tagLabel.font = Styles.Font.articleTag

    titleLabel.font = Styles.Font.articleLargeTitle

    subtitleLabel.numberOfLines = 4
    subtitleLabel.lineBreakMode = .byWordWrapping
    subtitleLabel.font = Styles.Font.articleMediumTitle

    actionBtn.titleLabel?.font = Styles.Font.moreActionTitle
  }
}

extension PBSArticleBigCardECell: PBSArticleCellProtocol {
  func render(theme: PBSArticleSectionTheme, model: PBSArticleViewModel) {
    applyStyle(theme: theme)

    model.coverImageUrl.bind(to: coverImageView.rx.imageUrl).disposed(by: disposeBag)
    model.tag.bind(to: tagLabel.rx.text).disposed(by: disposeBag)
    model.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.subtitle.bind(to: subtitleLabel.rx.text).disposed(by: disposeBag)

    actionBtn.setTitle("Read the collection ▶︎", for: .normal)
  }
}
