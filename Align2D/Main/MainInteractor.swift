    //
    //  MainInteractor.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import UIKit

protocol MainBusinessLogic {
    func fetchVectors(request: MainModel.ShowVectors.Request)
    func deleteVector(request: MainModel.deleteVector.Request)
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
                    print(error.localizedDescription)
            }
        }
    }

    func deleteVector(request: MainModel.deleteVector.Request) {
        worker.deleteVector(vector: request.vector) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success:
                    self.fetchVectors(request: MainModel.ShowVectors.Request())
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
