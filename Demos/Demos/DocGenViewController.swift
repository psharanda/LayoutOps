//
//  Created by Pavel Sharanda on 11.11.16.
//  Copyright © 2016 psharanda. All rights reserved.
//

import UIKit

class DocGenViewController: UIViewController {
    
    fileprivate let sections: [Section]
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        makeSnapshots()
    }
    
    fileprivate struct SectionRow {
        let sectionTitle: String
        let row: RowProtocol
    }

    fileprivate func makeSnapshots() {
        warnAboutSRCROOT = true
        let allRows = sections.flatMap { section in
            section.rows.map {
                SectionRow(sectionTitle: section.title, row: $0)
            }
        }
        
        let codebaseString = (try! NSString(contentsOfFile: Bundle.main.path(forResource: "Codebase.generated.txt", ofType: nil)!, encoding: String.Encoding.utf8.rawValue)) as String
        
        var currentRowIndex = 0
        
        var markdownString = ""
        
        var currentSectionString = ""
        
        
        func renderRow(_ completion: @escaping ()->Void) {
            
            
            let sectionRow = allRows[currentRowIndex]
            
            if currentSectionString != sectionRow.sectionTitle {
                currentSectionString = sectionRow.sectionTitle
                markdownString += "### \(currentSectionString)"
                markdownString += "\n"
            }
            
            markdownString += "#### \(sectionRow.row.title)"
            markdownString += "\n"
            markdownString += sectionRow.row.comments
            markdownString += "\n"
            
            let v1 = sectionRow.row.view
            view.addSubview(v1)
            v1.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
            v1.layoutIfNeeded()
            v1.backgroundColor = UIColor(white: 0.9, alpha: 1)
            

            let layoutCode = extractLayoutSourceCode(codebaseString , view: v1)
            
            markdownString += "```swift"
            markdownString += "\n"
            markdownString += layoutCode
            markdownString += "\n"
            markdownString += "```"
            markdownString += "\n"
            
            let v2 = sectionRow.row.view
            view.addSubview(v2)
            v2.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
            v2.layoutIfNeeded()
            v2.backgroundColor = UIColor(white: 0.9, alpha: 1)
            
            after {
                let f1 = "\(sectionRow.sectionTitle)_\(sectionRow.row.title)_portrait.png".stringForFilePath
                let img1 = imageWithView(v1)
                saveImageAsPngInTempFolder(img1, name: f1)
                v1.removeFromSuperview()
                
                let f2 = "\(sectionRow.sectionTitle)__\(sectionRow.row.title)_landscape.png".stringForFilePath
                let img2 = imageWithView(v2)
                saveImageAsPngInTempFolder(img2, name: f2)
                v2.removeFromSuperview()
                
                markdownString += "<img src=\"https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/\(f1)\" alt=\"\(sectionRow.row.title)\" width=\"\(img1.size.width/2)\" height=\"\(img1.size.height/2)\"/> "
                markdownString += "<img src=\"https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/\(f2)\" alt=\"\(sectionRow.row.title)\" width=\"\(img2.size.width/2)\" height=\"\(img2.size.height/2)\"/>"
                markdownString += "\n"
                
                currentRowIndex += 1
                if currentRowIndex >= allRows.count {
                    completion()
                } else {
                    renderRow(completion)
                }
            }
        }

        renderRow {
            let mdPath = (documentationPath() as NSString).appendingPathComponent("DEMOS.md")
            let _ = try?(markdownString as NSString).write(toFile: mdPath, atomically: false, encoding: String.Encoding.utf8.rawValue)
            print("Documentation saved to "+documentationPath())
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

private func extractLayoutSourceCode(_ codebase: String, view: UIView) -> String {
    
    let scanner = Scanner(string: codebase)
    scanner.charactersToBeSkipped = nil
    
    let className = String(describing: type(of: view))

    if scanner.scanUpToString("class \(className)") != nil {
        if scanner.scanUpToString("super.layoutSubviews()") != nil {
            if let code = scanner.scanUpToString("static") {
                var almostResult = code.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                almostResult = almostResult.trimmingCharacters(in: CharacterSet(charactersIn: "}"))
                almostResult = almostResult.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                return (almostResult as NSString).replacingOccurrences(of: "super.layoutSubviews()", with: "").replacingOccurrences(of: "\n        ", with: "\n")
            }
        }
    }

    return "<<error>>"
}

private func after(_ f: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: f)
}

private func imageWithView(_ view: UIView) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}

private func saveImageAsPngInTempFolder(_ image: UIImage, name: String) {
    
    #if swift(>=4.2)
    let imgData = image.pngData()
    #else
    let imgData = UIImagePNGRepresentation(image)
    #endif
    
    if let imgData = imgData {
        
        let imgPath = (documentationPath() as NSString).appendingPathComponent(name)
        try? imgData.write(to: URL(fileURLWithPath: imgPath), options: [])
    }
}

private func isSimulator() -> Bool {
    return TARGET_OS_SIMULATOR != 0
}

var warnAboutSRCROOT = true

private func documentationPath() -> String {
    if isSimulator() {
        if CommandLine.arguments.count < 2 {
            if warnAboutSRCROOT {
                print("WARNING: Add '$SRCROOT' to 'Arguments passed on launch' section to generate documentation in README folder")
                warnAboutSRCROOT = false
            }
            return NSTemporaryDirectory()
        } else {
            return ((CommandLine.arguments[1] as NSString).deletingLastPathComponent as NSString).appendingPathComponent("README")
        }
        
    } else {
        return NSTemporaryDirectory()
    }
}

extension String {
    var stringForFilePath: String {
        // characterSet contains all illegal characters on OS X and Windows
        let characterSet = CharacterSet(charactersIn: "\"\\/?<>:*|")
        // replace "-" with character of choice
        return components(separatedBy: characterSet).joined(separator: "-")
    }
}
