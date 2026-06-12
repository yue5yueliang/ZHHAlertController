//
//  ZHHExampleStepperCell.swift
//  ZHHAlertController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 加减步进数值行
final class ZHHExampleStepperCell: UITableViewCell {
    static let reuseID = "ZHHExampleStepperCell"

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private var minValue: CGFloat = 0
    private var maxValue: CGFloat = 0
    private var step: CGFloat = 1
    private var currentValue: CGFloat = 0
    private var onChange: ((CGFloat) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.font = .systemFont(ofSize: 15)
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        valueLabel.textAlignment = .center
        minusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        contentView.addSubview(titleLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(valueLabel)
        contentView.addSubview(plusButton)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 16
        let controlWidth: CGFloat = 32
        let valueWidth: CGFloat = 44
        let controlX = contentView.bounds.width - padding - controlWidth
        titleLabel.frame = CGRect(x: padding, y: 0, width: contentView.bounds.width - padding * 2 - controlWidth * 2 - valueWidth, height: contentView.bounds.height)
        plusButton.frame = CGRect(x: controlX, y: (contentView.bounds.height - 32) / 2, width: controlWidth, height: 32)
        valueLabel.frame = CGRect(x: plusButton.frame.minX - valueWidth, y: 0, width: valueWidth, height: contentView.bounds.height)
        minusButton.frame = CGRect(x: valueLabel.frame.minX - controlWidth, y: (contentView.bounds.height - 32) / 2, width: controlWidth, height: 32)
    }

    func configure(title: String, value: CGFloat, min: CGFloat, max: CGFloat, step: CGFloat, onChange: @escaping (CGFloat) -> Void) {
        titleLabel.text = title
        minValue = min
        maxValue = max
        self.step = step
        currentValue = value
        self.onChange = onChange
        refreshUI()
    }

    @objc private func minusTapped() {
        currentValue = max(minValue, currentValue - step)
        refreshUI()
        onChange?(currentValue)
    }

    @objc private func plusTapped() {
        currentValue = min(maxValue, currentValue + step)
        refreshUI()
        onChange?(currentValue)
    }

    /// 到边界时禁用对应按钮
    private func refreshUI() {
        valueLabel.text = "\(Int(currentValue.rounded()))"
        minusButton.isEnabled = currentValue > minValue
        plusButton.isEnabled = currentValue < maxValue
        minusButton.alpha = minusButton.isEnabled ? 1 : 0.35
        plusButton.alpha = plusButton.isEnabled ? 1 : 0.35
    }
}
