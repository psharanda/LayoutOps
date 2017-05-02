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
    
    init() {
        self.name = ""
        self.username = ""
        self.displayableDate = ""
        self.tweet = ""
        self.thumbnail = nil
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
        return (0..<500).map { _ in  [tweetFelix, tweetEloy, tweetJavi, tweetNacho] }.flatMap { $0 }
    }
    
}

//class TableViewController: UIViewController {
//    
//    fileprivate lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: CGRect(), style: .plain)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        return tableView
//    }()
//    
//    fileprivate var nodeModels: [(TweetModel, RootNode)] = []
//    private var referenceWidth: CGFloat = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "Table Demo"
//        view.addSubview(tableView)
//        
//        nodeModels = TweetModel.stubData().map { ($0, RootNode())}
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.lx.fill()
//        
//        let width = tableView.frame.width
//        
//        if width != referenceWidth {
//            referenceWidth = width
//            
//            let dateStart = Date()
//            let models = nodeModels.map { $0.0 }
//            DispatchQueue.global(qos: .background).async {
//                models.parallelMap(striding: 2, filler: (TweetModel(), RootNode()), f:  {
//                    ($0, TweetCell.buildRootNode($0, width: width))
//                }) {[weak self] in
//                    print("did cache in \(Date().timeIntervalSince(dateStart))s")
//                    self?.didLoad(nodeModels: $0, width: width)
//                }
//            }
//        }
//    }
//    
//    private func didLoad(nodeModels: [(TweetModel, RootNode)], width: CGFloat) {
//        
//        if width == referenceWidth {
//            self.nodeModels = nodeModels
//        }
//    }
//}
//
//extension TableViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nodeModels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellId = "CellId"
//        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? TweetCell) ?? TweetCell(style: .default, reuseIdentifier: cellId)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as? TweetCell)?.rootNode = nodeModels[indexPath.row].1
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let (model, rootNode) = nodeModels[indexPath.row]
//        
//        if rootNode.frame.width != tableView.frame.width {
//            let newRootNode = TweetCell.buildRootNode(model, width: tableView.frame.width)
//            nodeModels[indexPath.row] = (model, newRootNode)
//            
//            if let cell = tableView.cellForRow(at: indexPath) {
//                if let cell = cell as? TweetCell {
//                    cell.rootNode = newRootNode
//                }
//            }
//        }
//        
//        return nodeModels[indexPath.row].1.frame.height
//    }
//}

class TableViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    fileprivate var tweets: [TweetModel] = TweetModel.stubData()
    
    private var referenceWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table Demo"
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.lx.fill()
    }
    
    fileprivate lazy var adapter: TableViewDisplayAdapter = { [unowned self] in
        return TableViewDisplayAdapter(headerNodeForSection: { index, estimated in
            return TweetCell.headerRootNode(title: "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", estimated: estimated)
        }, cellNodeForIndexPath: { indexPath, estimated in
            return TweetCell.buildRootNode(self.tweets[indexPath.row], estimated: estimated)
        })
    }()
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func cellForRowAt<T: NodeTableViewCell>(indexPath: IndexPath, reuseIdentifier: String  = String(describing: T.self)) -> T {
        return (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T)  ?? T(reuseIdentifier: reuseIdentifier)
    }
    
    public func viewForFooterInSection<T: NodeTableHeaderFooterView>(section: Int, reuseIdentifier: String  = String(describing: T.self)) -> T {
        return (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T)  ?? T(reuseIdentifier: reuseIdentifier)
    }
    
    public func viewForHeaderInSection<T: NodeTableHeaderFooterView>(section: Int, reuseIdentifier: String  = String(describing: T.self)) -> T {
        return (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T)  ?? T(reuseIdentifier: reuseIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //adapted
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        adapter.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(section: section)
    }
    
    //rows
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(section: section)
    }
    
    //footers
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForFooterInSection: section)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        adapter.tableView(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    //headers
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        adapter.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
}

enum TweetCell {
    
    enum Tags: String, TagConvertible {
        case user
        case tweet
        case avatar
        case timestamp
    }
    
    static func labelNodeText_userInfo(model: TweetModel, estimated: Bool) -> LabelNodeString {
        if estimated {
            let e = LabelNodeEstimation(length: model.name.characters.count + model.username.characters.count + 1, font: .boldSystemFont(ofSize: 12.0))
            return .estimated(e)
        } else {
            return .attributed(TweetCell.attributedStringWithName(model.name, username: model.username))
        }
    }
    
    static func labelNodeText_displayableDate(model: TweetModel, estimated: Bool) -> LabelNodeString {
        if estimated {
            let e = LabelNodeEstimation(length: 10, font: .systemFont(ofSize: 14.0))
            return .estimated(e)
        } else {
            return .attributed(TweetCell.attributedStringWithDisplayableDate(model.displayableDate))
        }
    }
    
    static func labelNodeText_tweet(model: TweetModel, estimated: Bool) -> LabelNodeString {
        if estimated {
            let e = LabelNodeEstimation(length: model.tweet.characters.count, font: .systemFont(ofSize: 15.0), numberOfLines: Int.max, lineHeightMultiple: 1.2)
            return .estimated(e)
        } else {
            return .attributed(TweetCell.attributedStringWithTweet(model.tweet))
        }
    }
    
    static func headerRootNode(title: String, estimated: Bool) -> RootNode {
        if estimated {
            return RootNode(estimatedHeight: 40)
        }
        
        let titleNode = LabelNode(tag: "title", text: .regular(title, UIFont.boldSystemFont(ofSize: 12)), numberOfLines: 0) {
            return $0 ?? UILabel()
        }
        
        let rootNode = RootNode(subnodes: [titleNode]) { rootNode in
            let pad: CGFloat = 12
            titleNode.lx.hfillvfit(inset: pad)
            rootNode.lx.vwrap(
                Fix(pad),
                Fix(titleNode),
                Fix(pad)
            )
        }
        
        return rootNode
    }
    
    static func buildRootNode(_ model: TweetModel, estimated: Bool) -> RootNode {
    
        if estimated {
            return RootNode(estimatedHeight: 100)
        }

        //prepare attributed strings
        let userInfo = labelNodeText_userInfo(model: model, estimated: estimated)
        let displayableDate = labelNodeText_displayableDate(model: model, estimated: estimated)
        let tweet = labelNodeText_tweet(model: model, estimated: estimated)
        
        //setup hierarchy
        let avatarNode = ImageNode(tag: Tags.avatar, image: model.thumbnail) {
            let imageView = $0 ?? UIImageView()
            imageView.backgroundColor = UIColor.lightGray
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 6.0
            return imageView
        }
        
        let userNode = LabelNode(tag: Tags.user, text: userInfo) {
            return $0 ?? UILabel()
        }
        
        let tweetNode = LabelNode(tag: Tags.tweet, text: tweet, numberOfLines: 0) {
            return $0 ?? UILabel()
        }
        
        let timeStampNode = LabelNode(tag: Tags.timestamp, text: displayableDate) {
            return $0 ?? UILabel()
        }
        
        let rootNode = RootNode(subnodes: [avatarNode, userNode, tweetNode, timeStampNode]) { rootNode in
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
        }
        
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

extension Array {
    func parallelMap<R>(striding n: Int, filler: R, f: @escaping (Element) -> R, completion: @escaping ([R]) -> ()) {
        let N = self.count
        
        var finalResult = Array<R>(repeating: filler, count: N)
        
        finalResult.withUnsafeMutableBufferPointer { res in
            DispatchQueue.concurrentPerform(iterations: N/n) { k in
                for i in (k * n)..<((k + 1) * n) {
                    res[i] = f(self[i])
                }
            }
        }
        
        for i in (N - (N % n))..<N {
            finalResult[i] = f(self[i])
        }
        
        DispatchQueue.main.async {
            completion(finalResult)
        }
    }
}

extension RootNode {
    convenience init() {
        self.init(subnodes: [], layout: { _ in })
    }
}
