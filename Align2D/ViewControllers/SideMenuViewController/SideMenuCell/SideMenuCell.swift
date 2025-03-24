
import UIKit

protocol SideCellModelProtocol {
    var viewModel: SideMenuCellModelProtocol? { get }
}

final class SideMenuCell: UITableViewCell {

    private lazy var containerView: UIView = {
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())

    private lazy var titleLabel: UILabel = {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .darkText
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private lazy var coordinatesLabel: UILabel = {
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .darkText
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    var viewModel: SideMenuCellModelProtocol? {
        didSet {
            setupCell()
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if let viewModel = viewModel as? SideViewModel {
            containerView.backgroundColor = highlighted ?
            UIColor(hexString: viewModel.color).withAlphaComponent(0.3) :
                .clear
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        containerView.addSubviews(titleLabel, coordinatesLabel)
        contentView.addSubviews(containerView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell() {
        guard let viewModel = viewModel as? SideViewModel else { return }
        containerView.layer.borderColor = UIColor(hexString: viewModel.color).cgColor
        coordinatesLabel.text = String(format: "x: %.1f, y: %.1f", viewModel.x, viewModel.y)
        titleLabel.text = String(format: "Lenght: %.1f", viewModel.lenght)
        setupConstraints()
    }
}

private extension SideMenuCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            coordinatesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            coordinatesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            coordinatesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            coordinatesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
    }
}
