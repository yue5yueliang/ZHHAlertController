//
//  ZHHExampleTextCell.swift
//  ZHHAlertController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 文本输入行（当前配置页未使用，保留供扩展）
final class ZHHExampleTextCell: UITableViewCell {
    static let reuseID = "ZHHExampleTextCell"

    private let titleLabel = UILabel()
    private let textField = UITextField()
    private var onChange: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.font = .systemFont(ofSize: 15)
        textField.font = .systemFont(ofSize: 15)
        textField.textAlignment = .right
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 16
        titleLabel.frame = CGRect(x: padding, y: 0, width: 80, height: contentView.bounds.height)
        textField.frame = CGRect(x: 100, y: 0, width: contentView.bounds.width - 116, height: contentView.bounds.height)
    }

    func configure(title: String, text: String, placeholder: String, onChange: @escaping (String) -> Void) {
        titleLabel.text = title
        textField.text = text
        textField.placeholder = placeholder
        self.onChange = onChange
    }

    @objc private func textChanged() {
        onChange?(textField.text ?? "")
    }
}
