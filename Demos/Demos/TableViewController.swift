//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

// Sample was borrowed from EasyPeasy https://github.com/nakiostudio/EasyPeasy/blob/master/Example/EasyPeasy/TweetView.swift


import UIKit
import LayoutOps

struct TweetModel {
    
    let name: String
    let username: String
    let displayableDate: String
    let tweet: String
    let thumbnail: UIImage?
    
    init(name: String, username: String, displayableDate: String, tweet: String, thumbnail: UIImage?) {
        self.name = name
        self.username = username
        self.displayableDate = displayableDate
        self.tweet = tweet
        self.thumbnail = thumbnail
    }
    
}

extension TweetModel {
    
    static func stubData() -> [TweetModel] {
        let tweetFelix = TweetModel(
            name: "Felix Krause",
            username: "@KrauseFX",
            displayableDate: "30m",
            tweet: "With Fastlane nobody has to deal with xcodebuild anymore. Say goodbye to autolayout thanks to LayoutOps 🚀",
            thumbnail: #imageLiteral(resourceName: "thumb-felix")
        )
        let tweetEloy = TweetModel(
            name: "Eloy Durán",
            username: "@alloy",
            displayableDate: "1h",
            tweet: "LayoutOps, best thing since CocoaPods socks were announced!",
            thumbnail: #imageLiteral(resourceName: "thumb-eloy")
        )
        let tweetJavi = TweetModel(
            name: "Javi.swift",
            username: "@Javi",
            displayableDate: "2h",
            tweet: "LayoutOps? another autolayout library? not autolayout????? Okay, I can give it a try!",
            thumbnail: #imageLiteral(resourceName: "thumb-javi")
        )
        let tweetNacho = TweetModel(
            name: "NeoGazpatchOS",
            username: "@NeoNacho",
            displayableDate: "4h",
            tweet: "Just discovered LayoutOps... silly name, great framework #yatusabes",
            thumbnail: #imageLiteral(resourceName: "thumb-nacho")
        )
        return (0...20).map { _ in  [tweetFelix, tweetEloy, tweetJavi, tweetNacho] }.flatMap { $0 }
    }
    
}

class TableViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var cellNodes: [RootNode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table Demo"
        view.addSubview(tableView)
        
        // precache cell nodes, this can be moved to background queue
        let width = view.frame.width
        
        //kind of background fetching and caching
        DispatchQueue.global(qos: .background).async {
            let nodes = TweetModel.stubData().map { TweetCell.buildRootNode($0, width: width)}
            DispatchQueue.main.async {[weak self] in
                self?.cellNodes = nodes
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.lx.fill()
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? TweetCell) ?? TweetCell(style: .default, reuseIdentifier: cellId)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? TweetCell)?.rootNode = cellNodes[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellNodes[indexPath.row].frame.height
    }
}

class MyView: UIView {
    
    var color: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }
}

class TweetCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootNode?.installInRootView(contentView)
    }
    
    enum Tags: String, Taggable {
        case user
        case tweet
        case avatar
        case timestamp
    }
    var rootNode: RootNode?
    
    static func buildRootNode(_ model: TweetModel, width: CGFloat) -> RootNode {
        
        //prepare attributed strings
        let userInfo = TweetCell.attributedStringWithName(model.name, username: model.username)
        let displayableDate = TweetCell.attributedStringWithDisplayableDate(model.displayableDate)
        let tweet = TweetCell.attributedStringWithTweet(model.tweet)
        
        //setup hierarchy
        let avatarNode = ImageNode(tag: Tags.avatar, image: model.thumbnail) {
            let imageView = $0 ?? UIImageView()
            imageView.backgroundColor = UIColor.lightGray
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 6.0
            return imageView
        }
        
        let userNode = LabelNode(tag: Tags.user, text: .attributed(userInfo)) {
            return $0 ?? UILabel()
        }
        
        let tweetNode = LabelNode(tag: Tags.tweet, text: .attributed(tweet), numberOfLines: 0) {
            return $0 ?? UILabel()
        }
        
        let timeStampNode = LabelNode(tag: Tags.timestamp, text: .attributed(displayableDate)) {
            return $0 ?? UILabel()
        }
        
        let rootNode = RootNode(size: CGSize(width: width, height: 0), subnodes: [avatarNode, userNode, tweetNode, timeStampNode])
        
        let pad: CGFloat = 12
        
        //layout
        avatarNode.lx.set(x: pad, y: pad, width: 52, height: 52)
        
        timeStampNode.lx.sizeToFitMax(widthConstraint: .max(40))
        
        rootNode.lx.inViewport(leftAnchor: avatarNode.lx.rightAnchor) {
            rootNode.lx.hput(
                Fix(pad),
                Flex(userNode),
                Fix(pad),
                Fix(timeStampNode),
                Fix(pad)
            )
            
            rootNode.lx.hput(
                Fix(pad),
                Flex(tweetNode),
                Fix(pad)
            )
        }
        
        userNode.lx.setHeightAsLineHeight()
        
        tweetNode.lx.sizeToFit(width: .keepCurrent, height: .max, heightConstraint: .min(20))
        
        rootNode.lx.vput(
            Fix(pad),
            Fix(userNode),
            Fix(tweetNode)
        )
        
        timeStampNode.lx.firstBaselineAnchor.follow(userNode.lx.firstBaselineAnchor)

        //calculate final cell height
        rootNode.frame.size.height = max(tweetNode.frame.maxY + pad, avatarNode.frame.maxY + pad)
        
        return rootNode
    }
}

/**
 NSAttributedString factory methods
 */
extension TweetCell {
    
    @nonobjc static let darkGreyColor = UIColor(red: 140.0/255.0, green: 157.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    @nonobjc static let lightBlueColor = UIColor(red: 33.0/255.0, green: 151.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    
    static func attributedStringWithDisplayableDate(_ string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: TweetCell.darkGreyColor
        ]
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    static func attributedStringWithTweet(_ tweet: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 1.2
        let attributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        let string = NSMutableAttributedString(string: tweet, attributes: attributes)
        
        for hashtagRange in tweet.easy_hashtagRanges() {
            string.addAttribute(NSForegroundColorAttributeName, value: TweetCell.lightBlueColor, range: hashtagRange)
        }
        
        return string
    }
    
    static func attributedStringWithName(_ name: String, username: String) -> NSAttributedString {
        let string = "\(name) \(username)"
        let boldAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        let lightAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: TweetCell.darkGreyColor
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: boldAttributes)
        let range = (string as NSString).range(of: username)
        attributedString.addAttributes(lightAttributes, range: range)
        
        return attributedString
    }
    
}

extension String {
    
    private static let regex = try! NSRegularExpression(
        pattern: "#\\w+",
        options: .caseInsensitive
    )
    
    func easy_hashtagRanges() -> [NSRange] {
        let matches = String.regex.matches(
            in: self,
            options: .reportCompletion,
            range: NSMakeRange(0, self.characters.count)
        )
        
        return matches.map { $0.range }
    }
    
}
