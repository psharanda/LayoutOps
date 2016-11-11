//
//  Created by Pavel Sharanda on 11.11.16.
//  Copyright © 2016 psharanda. All rights reserved.
//

import UIKit

class DocGenViewController: UIViewController {
    
    private let sections: [Section]
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        makeSnapshots()
    }
    
    private struct SectionRow {
        let sectionTitle: String
        let row: RowProtocol
    }

    private func makeSnapshots() {
        
        let allRows = sections.flatMap { section in
            section.rows.map {
                SectionRow(sectionTitle: section.title, row: $0)
            }
        }
        var currentRowIndex = 0
        
        var markdownString = ""
        
        var currentSectionString = ""
        
        
        func renderRow(completion: ()->Void) {
            
            
            let sectionRow = allRows[currentRowIndex]
            
            if currentSectionString != sectionRow.sectionTitle {
                currentSectionString = sectionRow.sectionTitle
                markdownString += "### \(currentSectionString)"
                markdownString += "\n\r"
            }
            
            markdownString += "#### \(sectionRow.row.title)"
            markdownString += "\n\r"
            markdownString += sectionRow.row.comments
            markdownString += "\n\r"
            
            let v1 = sectionRow.row.view
            view.addSubview(v1)
            v1.frame = CGRectMake(0, 0, 320, 480)
            v1.layoutIfNeeded()
            v1.backgroundColor = UIColor(white: 0.9, alpha: 1)
            
            let v2 = sectionRow.row.view
            view.addSubview(v2)
            v2.frame = CGRectMake(0, 0, 480, 320)
            v2.layoutIfNeeded()
            v2.backgroundColor = UIColor(white: 0.9, alpha: 1)
            
            after {
                let f1 = "\(sectionRow.sectionTitle)_\(sectionRow.row.title)_portrait.png"
                let img1 = imageWithView(v1)
                saveImageAsPngInTempFolder(img1, name: f1)
                v1.removeFromSuperview()
                
                let f2 = "\(sectionRow.sectionTitle)__\(sectionRow.row.title)_landscape.png"
                let img2 = imageWithView(v2)
                saveImageAsPngInTempFolder(img2, name: f2)
                v2.removeFromSuperview()
                
                markdownString += "<img src=\"https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/\(f1)\" alt=\"\(sectionRow.row.title)\" width=\"\(img1.size.width/2)\" height=\"\(img1.size.height/2)\"/>"
                markdownString += "\n\r"
                markdownString += "<img src=\"https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/\(f2)\" alt=\"\(sectionRow.row.title)\" width=\"\(img2.size.width/2)\" height=\"\(img2.size.height/2)\"/>"
                markdownString += "\n\r"
                
                currentRowIndex += 1
                if currentRowIndex >= allRows.count {
                    completion()
                } else {
                    renderRow(completion)
                }
            }
        }

        renderRow {
            let mdPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("DEMOS.md")
            let _ = try?(markdownString as NSString).writeToFile(mdPath, atomically: false, encoding: NSUTF8StringEncoding)
            print("Markdown saved to "+mdPath)
        }
    }
    

}

private func after(f: ()->Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), f)
}

private func imageWithView(view: UIView) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
}

private func saveImageAsPngInTempFolder(image: UIImage, name: String) {
    if let imgData = UIImagePNGRepresentation(image) {
        
        let imgPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(name)
        print("image saved to "+imgPath)
        imgData.writeToFile(imgPath, atomically: false)
    }
}

