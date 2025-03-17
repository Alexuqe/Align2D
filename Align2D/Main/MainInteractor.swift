    //
    //  MainInteractor.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainBusinessLogic {
    func fetchVectors(request: MainModel.ShowVectors.Request)
    func addVectors(request: MainModel.addVector.Request)
    func deleteVector(request: MainModel.deleteVector.Request)
    func panCanvas(request: MainModel.Gesture.Request)
}

final class MainInteractor: MainBusinessLogic {

    var presenter: MainPresentationLogic?
    var worker = MainWorker()
    private var canvasOffset: CGPoint = .zero

    func fetchVectors(request: MainModel.ShowVectors.Request) {
        worker.fetchVector { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let vectors):
                    let response = MainModel.ShowVectors.Response(vectors: vectors)
                    self.presenter?.presentVectors(responce: response)
                case .failure(let error):
                    self.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }

    func addVectors(request: MainModel.addVector.Request) {
        let vector = VectorDataModel(
            id: UUID(),
            startPoint: request.start,
            endPoint: request.end,
            color: request.color)

        worker.saveVector(model: vector) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success():
                    self.fetchVectors(request: MainModel.ShowVectors.Request())
                case .failure(let error):
                    self.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }

    func deleteVector(request: MainModel.deleteVector.Request) {
        worker.deleteVector(by: request.vectorID) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success:
                    self.fetchVectors(request: MainModel.ShowVectors.Request())
                case .failure(let error):
                    self.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }

    func panCanvas(request: MainModel.Gesture.Request) {
        canvasOffset.x += request.translation.x
        canvasOffset.y += request.translation.y

        presenter?.updateGesture(offset: canvasOffset)
    }
}
