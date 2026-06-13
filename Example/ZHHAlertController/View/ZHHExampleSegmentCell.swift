//
//  ZHHExampleSegmentCell.swift
//  ZHHAlertController
//
//  Created by 桃色三岁y on 07/26/2022.
//  Copyright (c) 2022 桃色三岁y. All rights reserved.
//

import UIKit

/// 分段选择行（动画 / 展示方式）
final class ZHHExampleSegmentCell: UITableViewCell {
    static let reuseID = "ZHHExampleSegmentCell"

    private let titleLabel = UILabel()
    private let segment = UISegmentedControl()
    private var onChange: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.font = .systemFont(ofSize: 15)
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        contentView.addSubview(titleLabel)
        contentView.addSubview(segment)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 16
        titleLabel.frame = CGRect(x: padding, y: 8, width: contentView.bounds.width - padding * 2, height: 20)
        segment.frame = CGRect(x: padding, y: 34, width: contentView.bounds.width - padding * 2, height: 44)
    }

    func configure(title: String, options: [String], selectedIndex: Int, onChange: @escaping (Int) -> Void) {
        titleLabel.text = title
        segment.removeAllSegments()
        for (index, option) in options.enumerated() {
            segment.insertSegment(withTitle: option, at: index, animated: false)
        }
        segment.selectedSegmentIndex = min(max(selectedIndex, 0), options.count - 1)
        self.onChange = onChange
    }

    @objc private func segmentChanged() {
        onChange?(segment.selectedSegmentIndex)
    }
}
