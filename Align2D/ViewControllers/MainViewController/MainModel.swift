import UIKit

typealias MainViewModels = MainModel.ShowVectors.ViewModel.DisplayedVector

protocol MainModelProtocol {
    var id: UUID { get }
    var startX: CGFloat { get }
    var startY: CGFloat { get }
    var endX: CGFloat { get }
    var endY: CGFloat { get }
    var color: String { get }

    var vector: VectorEntity { get set }
    init(vectors: VectorEntity)
}


enum MainModel {
    
    enum ShowVectors {
        struct Request {}
        struct Response {
            let vectors: [VectorEntity]
        }
        
        struct ViewModel {
            struct DisplayedVector: MainModelProtocol {

                var id: UUID {
                    vector.id ?? UUID()
                }

                var startX: CGFloat {
                    vector.startX
                }

                var startY: CGFloat {
                    vector.startY
                }

                var endX: CGFloat {
                    vector.endX
                }
                var endY: CGFloat {
                    vector.endY
                }

                var color: String {
                    vector.color ?? ""
                }

                var vector: VectorEntity

                init(vectors: VectorEntity) {
                    self.vector = vectors
                }
            }
            let vectors: [MainModelProtocol]
        }
    }
    
    enum addVector {
        struct Request {
            let startX: CGFloat
            let startY: CGFloat
            let endX: CGFloat
            let endY: CGFloat
            let color: String
        }
        
        struct Response {
            let succes: Bool
        }
        
        struct ViewModel {
            let successMessage: String?
            let errorMessage: String?
        }
    }
    
    enum deleteVector {
        struct Request {
            let vector: VectorEntity
        }
    }
}
