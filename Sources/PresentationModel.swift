//
//  Created by Pavel Sharanda on 27.08.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol PresentationModelProtocol {
    func calculate(for size: CGSize) -> CGSize
}

public protocol PresentationModelViewProtocol: class {
    associatedtype PresentationModelType: PresentationModelProtocol
    var presentationModel: PresentationModelType? {get set}
}

extension RootNode: PresentationModelProtocol { }

#endif
