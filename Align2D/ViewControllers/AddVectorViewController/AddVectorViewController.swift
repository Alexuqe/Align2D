import UIKit

protocol AddVectorDisplayLogic: AnyObject {
    func displayAddVectorResult(viewModel: AddVectorModel.AddNewVector.ViewModel)
    func addVector()
}


final class AddVectorViewController: UIViewController {

    enum PointsText {
        case startX
        case startY
        case endX
        case endY

        var text: String {
            switch self {
                case .startX:
                    "Start x-point"
                case .startY:
                    "Start y-point"
                case .endX:
                    "End x-point"
                case .endY:
                    "End y-point"
            }
        }
    }

        //MARK: UI Components
    private lazy var startXTextField = UITextField(placeholder: PointsText.startX.text)
    private lazy var  startYTextField = UITextField(placeholder: PointsText.startY.text)
    private lazy var  endXTextField = UITextField(placeholder: PointsText.endX.text)
    private lazy var  endYTextField = UITextField(placeholder: PointsText.endY.text)

    private lazy var  startXLabel = UILabel(text: PointsText.startX.text)
    private lazy var  startYLabel = UILabel(text: PointsText.startY.text)
    private lazy var  endXLabel = UILabel(text: PointsText.endX.text)
    private lazy var  endYLabel = UILabel(text: PointsText.endY.text)

    private lazy var saveButton = UIButton(
        backgroundColor: .systemBlue,
        foregroundColor: .white,
        title: "Save",
        target: self,
        action: #selector(buttonSaveAction)
    )

    private lazy var cancelButton = UIButton(
        backgroundColor: .systemRed,
        foregroundColor: .white,
        title: "Cancel",
        target: self,
        action: #selector(buttonCancelAction)
    )

        //MARK: - Properties
    var interactor: AddVectorBusinessLogic?
    var router: AddVectorRoutingLogic?
    var mainInteractor: MainBusinessLogic?

    private let configurator = AddVectorConfigurator.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    @objc private func buttonSaveAction() {
        addVector()
    }
    
    @objc private func buttonCancelAction() {
        router?.closeAddVectorScreen()
    }

}

    //MARK: - Setup UI
private extension AddVectorViewController {

    func setupUI() {
        setupTextField(startXTextField, startYTextField, endXTextField, endYTextField)

        view.addSubviews(startXTextField, startYTextField, endXTextField, endYTextField)
        view.addSubviews(startXLabel, startYLabel, endXLabel, endYLabel)
        view.addSubviews(saveButton, cancelButton)

        setupStartXConstraints()
        setupStartYConstraints()
        setupEndXConstraints()
        setupEndYConstraints()
        setupConstraintsButtons()
    }

    func setupTextField(_ textFields: UITextField...) {
        textFields.forEach { textField in
            textField.delegate = self
            textField.keyboardType = .numbersAndPunctuation
        }
    }
}

    //    MARK: - Setup Constraints
private extension AddVectorViewController {

    func setupStartXConstraints() {
        NSLayoutConstraint.activate([
            startXLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            startXLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            startXTextField.topAnchor.constraint(equalTo: startXLabel.bottomAnchor, constant: 10),
            startXTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startXTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }

    func setupStartYConstraints() {
        NSLayoutConstraint.activate([
            startYLabel.topAnchor.constraint(equalTo: startXTextField.bottomAnchor, constant: 30),
            startYLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            startYTextField.topAnchor.constraint(equalTo: startYLabel.bottomAnchor, constant: 10),
            startYTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startYTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }

    func setupEndXConstraints() {
        NSLayoutConstraint.activate([
            endXLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            endXLabel.leadingAnchor.constraint(equalTo: endXTextField.leadingAnchor),
        ])

        NSLayoutConstraint.activate([
            endXTextField.topAnchor.constraint(equalTo: endXLabel.bottomAnchor, constant: 10),
            endXTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endXTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }

    func setupEndYConstraints() {
        NSLayoutConstraint.activate([
            endYLabel.topAnchor.constraint(equalTo: endXTextField.bottomAnchor, constant: 30),
            endYLabel.leadingAnchor.constraint(equalTo: endYTextField.leadingAnchor),
        ])

        NSLayoutConstraint.activate([
            endYTextField.topAnchor.constraint(equalTo: endYLabel.bottomAnchor, constant: 10),
            endYTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endYTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
    }

    func setupConstraintsButtons() {
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: startYTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension AddVectorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension AddVectorViewController: AddVectorDisplayLogic {

    func displayAddVectorResult(viewModel: AddVectorModel.AddNewVector.ViewModel) {
        if let succesMessage = viewModel.succesMessage {
            showAlert(message: succesMessage) { [weak self] in
                self?.router?.closeAddVectorScreen()
            }
        } else if let errorMesage = viewModel.errorMesage {
            showAlert(message: errorMesage)
        }
    }

    func addVector() {
        guard
            let startX = Double(startXTextField.text ?? ""),
            let startY = Double(startYTextField.text ?? ""),
            let endX = Double(endXTextField.text ?? ""),
            let endY = Double(endYTextField.text ?? "")
        else {

            return
        }

        let randomColor = UIColor.randomColor()

        let request = AddVectorModel.AddNewVector.Request(
            startX: startX,
            startY: startY,
            endX: endX,
            endY: endY,
            color: randomColor.hexString
        )

        interactor?.addVector(request: request)
    }
}



