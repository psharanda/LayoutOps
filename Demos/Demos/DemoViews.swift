//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

func makeViewWithColor(_ color: UIColor) -> UIView {
    let view = UIView()
    view.backgroundColor = color.withAlphaComponent(0.5)
    view.layer.borderWidth = 1
    view.layer.borderColor = color.cgColor
    return view
}

func makeGreenView() -> UIView {
    return makeViewWithColor(UIColor(red: 0x76/255.0, green: 0xDA/255.0, blue: 0xAC/255.0, alpha: 1))
}

func makeBlueView() -> UIView {
    return makeViewWithColor(UIColor(red: 0x20/255.0, green: 0x20/255.0, blue: 0x89/255.0, alpha: 1))
}

func makeRedView() -> UIView {
    return makeViewWithColor(UIColor(red: 0xF2/255.0, green: 0x1E/255.0, blue: 0x75/255.0, alpha: 1))
}

func makeAvatarView() -> UIImageView {
    return UIImageView(image: UIImage(named: "avatar"))
}

func makeHeartView() -> UIImageView {
    return UIImageView(image: UIImage(named: "heart"))
}

func makeTitleLabel() -> UILabel {
    let l = UILabel()
    l.text = "Lorem Ipsum"
    l.textColor = UIColor(red: 0x35/255.0, green: 0x35/255.0, blue: 0x56/255.0, alpha: 1)
    l.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    return l
}

func makeDetailsLabel() -> UILabel {
    let l = UILabel()
    l.text = "Cras mattis consectetur purus sit amet fermentum. Maecenas faucibus mollis interdum."
    l.numberOfLines = 0
    l.textColor = UIColor(red: 0xB1/255.0, green: 0xB1/255.0, blue: 0xC3/255.0, alpha: 1)
    l.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    return l
}
