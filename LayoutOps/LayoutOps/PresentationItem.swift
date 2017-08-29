//
//  PresentationItem.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 27.08.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol PresentationItemProtocol: class {
    func calculate(for size: CGSize) -> CGSize
}

public class PresentationItem<ViewType>: PresentationItemProtocol where ViewType: PresentationModelView  {
    
    public var model: ViewType.PresentationModelType
    
    public init(model: ViewType.PresentationModelType) {
        self.model = model
    }
    
    public func configureView(_ view: ViewType) {
        view.presentationModel = model
    }
    
    public func calculate(for size: CGSize) -> CGSize {
        return model.calculate(for: size)
    }
}
