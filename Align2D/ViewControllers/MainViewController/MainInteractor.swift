import UIKit

protocol MainBusinessLogic {
    func fetchVectors(request: MainModel.ShowVectors.Request)
    func saveVector(request: MainModel.addVector.Request)
    func deleteVector(request: MainModel.deleteVector.Request)
}

final class MainInteractor: MainBusinessLogic {

    var presenter: MainPresentationLogic?
    var worker = MainWorker()

    func fetchVectors(request: MainModel.ShowVectors.Request) {
        worker.fetchVector { result in
            switch result {
                case .success(let vectors):
                    let response = MainModel.ShowVectors.Response(vectors: vectors)
                    self.presenter?.presentVectors(response: response)
                case .failure(let error):
                    print("Ошибка загрузки \(error)")
            }
        }
    }

    func saveVector(request: MainModel.addVector.Request) {
        let vectorModel = VectorModel(
            id: UUID(),
            startX: request.startX,
            startY: request.startY,
            endX: request.endX,
            endY: request.endY,
            color: request.color
        )

        worker.saveVector(model: vectorModel) { [weak self] result in
            switch result {
                case .success:
                    self?.fetchVectors(request: MainModel.ShowVectors.Request())
                case .failure(_):
                    break
            }
        }
    }

    func deleteVector(request: MainModel.deleteVector.Request) {
        worker.deleteVector(vector: request.vector) { result in
            switch result {
                case .success:
                    self.fetchVectors(request: MainModel.ShowVectors.Request())
                case .failure(let error):
                    print("Ошибка удаления вектора \(error)")
            }
        }
    }
}
