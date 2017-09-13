//
//  Created by Pavel Sharanda on 27.08.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol PresentationModelProtocol {
    func calculate(for size: CGSize) -> CGSize
}

public protocol PresentationModelView: class {
    associatedtype PresentationModelType: PresentationModelProtocol
    var presentationModel: PresentationModelType? {get set}
}
