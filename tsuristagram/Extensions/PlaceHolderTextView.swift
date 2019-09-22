//
//  PlaceHolderTextView.swift
//  tsuristagram
//
//  Created by takuya nakazawa on 2019/09/19.
//  Copyright © 2019 takuya nakazawa. All rights reserved.
//

import UIKit

@IBDesignable class InspectableTextView: UITextView {
    
    // MARK: - プロパティ
    /// プレースホルダーに表示する文字列（ローカライズ付き）
    @IBInspectable var localizedString: String = "" {
        didSet {
            guard !localizedString.isEmpty else { return }
            // Localizable.stringsを参照する
            placeholderLabel.text = NSLocalizedString(localizedString, comment: "")
            print(localizedString)
            placeholderLabel.sizeToFit()  // 省略不可
        }
    }
    
    /// プレースホルダー用ラベルを作成
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 6, y: 6, width: 0, height: 0))
    
    // MARK: - Viewライフサイクルメソッド
    /// ロード後に呼ばれる
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        configurePlaceholder()
        togglePlaceholder()
    }
    
    /// プレースホルダーを設定する
    private func configurePlaceholder() {
        placeholderLabel.textColor = UIColor(white: 0.0, alpha: 0.21)
        addSubview(placeholderLabel)
    }
    
    /// プレースホルダーの表示・非表示切り替え
    func togglePlaceholder() {
        // テキスト未入力の場合のみプレースホルダーを表示する
        placeholderLabel.isHidden = self.text.isEmpty ? false : true
    }
    
    /// プレースホルダーの表示・非表示切り替え
    func togglePlaceholder(text: String) {
        // テキスト未入力の場合のみプレースホルダーを表示する
        placeholderLabel.isHidden = text.isEmpty ? false : true
    }

}

// MARK: -  UITextView Delegate
extension InspectableTextView: UITextViewDelegate {
    /// テキストが書き換えられるたびに呼ばれる ※privateにはできない
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholder()
    }
}
