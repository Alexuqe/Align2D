    //
    //  SideMenuModel.swift
    //  Align2D
    //
    //  Created by Sasha on 21.03.25.
    //

import Foundation

typealias SideMenuDeleteResponse = SideMenuModel.DeleteVector.Response
typealias SideMenuShowVectorsRequest = SideMenuModel.ShowVectors.Request
typealias SideViewModel = SideMenuModel.ShowVectors.ViewModel.DisplayedVector

protocol SideMenuCellModelProtocol {
    var identifier: String { get }
    var cellHeight: Double { get }
    var id: UUID { get }
    var x: CGFloat { get }
    var y: CGFloat { get }
    var color: String { get }
    var lenght: Double { get }
    var vector: VectorEntity { get set }
    
    init(vectors: VectorEntity)
}

enum SideMenuModel {
    enum ShowVectors {
        struct Request {}
        
        struct Response {
            let vectors: [VectorEntity]
        }
        
        struct ViewModel {
            struct DisplayedVector: SideMenuCellModelProtocol {
                var identifier: String {
                    "VectorsCell"
                }
                
                var cellHeight: Double {
                    50
                }
                
                var id: UUID {
                    vector.id ?? UUID()
                }
                
                var x: CGFloat {
                    vector.endX
                }
                
                var y: CGFloat {
                    vector.endY
                }
                
                var color: String  {
                    vector.color ?? ""
                }
                
                var lenght: Double {
                    let deltaX = vector.endX - vector.startX
                    let deltaY = vector.endY - vector.startY
                    return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
                }
                
                var vector: VectorEntity

                init(vectors: VectorEntity) {
                    self.vector = vectors
                }
            }
            
            let displayedVectors: [SideMenuCellModelProtocol]
        }
    }
    
    enum DeleteVector {
        struct Request {
            let vector: VectorEntity
        }
        
        struct Response {
            let vector: VectorEntity
            let success: Bool
        }
        
        struct ViewModel {
            let succesMessage: String
            let errorMessage: String?
        }
    }
    
    enum HiglightVector {
        struct Request {
            let vector: VectorEntity
        }
        
        struct Responce {
            let vector: VectorEntity
        }
    }
    
    enum ResetHighlight {
        struct Request {
            let vector: VectorEntity
        }
    }
}
