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

class TableViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    fileprivate var tweets: [TweetModel] = TweetModel.stubData()
    fileprivate var presentationCache: [(TweetModel, RootNode)]?
    
    private var referenceWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table Demo"
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let width = view.frame.width
        
        if width != referenceWidth {
            presentationCache = nil
            referenceWidth = width
            
            let dateStart = Date()
            let models = tweets
            DispatchQueue.global(qos: .background).async {
                let cachedModels: [(TweetModel, RootNode)] = models.concurrentMap  {
                    let node = TweetCell.buildRootNode($0, estimated: false)
                    _ = node.calculate(for: CGSize(width: width, height: 0))
                    return ($0, node)
                }
                
                DispatchQueue.main.async { [weak self] in
                    print("did cache in \(Date().timeIntervalSince(dateStart))s")
                    self?.didLoad(presentationCache: cachedModels, width: width)
                }
            }
        }
        
        tableView.lx.fill()
    }
    
    private func didLoad(presentationCache: [(TweetModel, RootNode)], width: CGFloat) {
        
        if width == referenceWidth {
            self.presentationCache = presentationCache
        }
    }
    
    fileprivate lazy var adapter: TableViewPresentationAdapter = { [unowned self] in
        return TableViewPresentationAdapter(presentationItemForHeader: { index, estimated in
            return NodeTableHeaderFooter(model: TweetCell.headerRootNode(title: "Cras justo odio, dapibus ac facilisis in, egestas eget quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", estimated: estimated))
        }, presentationItemForRow: { indexPath, estimated in
            if indexPath.section == 0 { 
                return tableRow(from: ClassicModel(title: "Hello Classic Cell"), estimated: estimated, cell: ClassicCell.self)
            } else {
                if let node = self.presentationCache?[indexPath.row]  {
                    return NodeTableRow(model: node.1)
                } else {
                    return NodeTableRow(model: TweetCell.buildRootNode(self.tweets[indexPath.row], estimated: estimated))
                }
            }
        })
    }()
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return tweets.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //adapted
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return adapter.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adapter.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return adapter.tableView(tableView, viewForFooterInSection: section)
    }
    
    //rows
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //footers
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForFooterInSection: section)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForFooterInSection: section)
    }
    
    //headers
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}

enum TweetCell {
    
    enum Tags: String, TagConvertible {
        case user
        case tweet
        case avatar
        case timestamp
    }
    
    static func labelNodeText_userInfo(model: TweetModel) -> LabelNodeString {
        return .attributed(TweetCell.attributedStringWithName(model.name, username: model.username))
    }
    
    static func labelNodeText_displayableDate(model: TweetModel) -> LabelNodeString {
        return .attributed(TweetCell.attributedStringWithDisplayableDate(model.displayableDate))
    }
    
    static func labelNodeText_tweet(model: TweetModel) -> LabelNodeString {
        return .attributed(TweetCell.attributedStringWithTweet(model.tweet))
    }
    
    static func headerRootNode(title: String, estimated: Bool) -> RootNode {
        if estimated {
            return RootNode(height: 40)
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
            return RootNode(height: 100)
        }

        //prepare attributed strings
        let userInfo = labelNodeText_userInfo(model: model)
        let displayableDate = labelNodeText_displayableDate(model: model)
        let tweet = labelNodeText_tweet(model: model)
        
        //setup hierarchy
        let avatarNode = ImageNode(tag: Tags.avatar, image: model.thumbnail) {
            let imageView = $0 ?? UIImageView()
            imageView.backgroundColor = UIColor.lightGray
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 6.0
            return imageView
        }
        
        let userNode = LabelNode(tag: Tags.user, text: userInfo, estimated: estimated) {
            return $0 ?? UILabel()
        }
        
        let tweetNode = LabelNode(tag: Tags.tweet, text: tweet, numberOfLines: 0, estimated: estimated) {
            return $0 ?? UILabel()
        }
        
        let timeStampNode = LabelNode(tag: Tags.timestamp, text: displayableDate, estimated: estimated) {
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
            
            if rootNode.frame.size.height > 10 { // in editing mode...
                let newTweetHeight = (rootNode.frame.height - pad - tweetNode.frame.minY)
                tweetNode.lx.set(height: newTweetHeight)
            }
            
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
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: TweetCell.darkGreyColor
        ]
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    static func attributedStringWithTweet(_ tweet: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        
        let string = NSMutableAttributedString(string: tweet, attributes: attributes)
        
        for hashtagRange in tweet.easy_hashtagRanges() {
            string.addAttribute(NSAttributedStringKey.foregroundColor, value: TweetCell.lightBlueColor, range: hashtagRange)
        }
        
        return string
    }
    
    static func attributedStringWithName(_ name: String, username: String) -> NSAttributedString {
        let string = "\(name) \(username)"
        let boldAttributes = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let lightAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: TweetCell.darkGreyColor
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

extension RandomAccessCollection {
    func concurrentMap<T>(_ transform: (Iterator.Element)->T) -> [T] {
        let n = numericCast(self.count) as Int
        let p = UnsafeMutablePointer<T>.allocate(capacity: n)
        defer { p.deallocate(capacity: n) }
        
        DispatchQueue.concurrentPerform(iterations: n) {
            offset in
            (p + offset).initialize(
                to: transform(
                    self[index(startIndex, offsetBy: numericCast(offset))]))
        }
        
        return Array(UnsafeMutableBufferPointer(start: p, count: n))
    }
}

/////

public enum CacheResult<T: HeightConvertible> {
    case precise(T)
    case estimated(CGFloat)
    
    public var height: CGFloat {
        switch self {
        case .estimated(let val):
            return val
        case .precise(let x):
            return x.height
        }
    }
    
    public var estimatedHeight: CGFloat? {
        switch self {
        case .estimated(let val):
            return val
        case .precise:
            return nil
        }
    }
    
    public var result: T? {
        switch self {
        case .estimated:
            return nil
        case .precise(let res):
            return res
        }
    }
}

public protocol HeightConvertible {
    var height: CGFloat {get}
}

extension CGFloat: HeightConvertible {
    public var height: CGFloat {
        return self
    }
}

/////////////////////////

struct PresentationModelAdaptor<ModelType>: PresentationModelProtocol {
    
    let model: ModelType
    let estimated: Bool
    let calc: (CGSize) -> CGSize
    
    
    init<T: PresentationModelConverter>(model: ModelType, estimated: Bool, converter: T.Type) where ModelType == T.ModelType {
        self.model = model
        self.estimated = estimated
        calc = {
            return CGSize(width: $0.width, height: converter.height(for: model, width: $0.width, estimated: estimated).height)
        }
    }
    
    func calculate(for size: CGSize) -> CGSize {
        return calc(size)
    }
}

protocol PresentationModelConverter {
    associatedtype ModelType
    associatedtype CacheType: HeightConvertible
    static func height(for model: ModelType, width: CGFloat, estimated: Bool) -> CacheResult<CacheType>
}

//////////////


struct ClassicModel {
    let title: String
}

class ClassicCell: UITableViewCell, PresentationModelViewProtocol, PresentationModelConverter {
    
    var presentationModel: PresentationModelAdaptor<ClassicModel>? {
        didSet {
            self.textLabel?.text = presentationModel?.model.title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            //presentationModel?.action()
        }
    }
    
    static func height(for model: ClassicModel, width: CGFloat, estimated: Bool) -> CacheResult<CGFloat> {
        return .precise(50)
    }
}

func tableRow<ModelType, CellType: UITableViewCell>(from model: ModelType, estimated: Bool, cell: CellType.Type, reuseIdentifier: String = String(describing: CellType.self), style: UITableViewCellStyle = .default) -> PresentationTableRow<CellType> where CellType: PresentationModelConverter & PresentationModelViewProtocol, CellType.ModelType == ModelType, CellType.PresentationModelType == PresentationModelAdaptor<ModelType> {
    let m =  PresentationModelAdaptor(model: model, estimated: estimated, converter: CellType.self)
    return PresentationTableRow<CellType>(model: m, reuseIdentifier: reuseIdentifier, style: style)
}

