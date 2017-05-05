import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    private let maxQueryLength = 60
    private var searchResultOfITunesEntity: [ITunesEntity] = []
    
    @IBOutlet weak var searchText: UITextView!
    @IBOutlet weak var searchResult: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchText.text = ""
        searchResult.delegate = self
        searchResult.dataSource = self
        ApplicationManager.sharedInstance.gotCurrentITunesEntity = gotCurrentITunesEntity
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultOfITunesEntity.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResult.dequeueReusableCell(withIdentifier: "iTunesEntityCell") as! CellITunesEntity
        cell.trackName.text = searchResultOfITunesEntity[indexPath.row].trackName
        if let url = URL(string: searchResultOfITunesEntity[indexPath.row].image) {
            if let data = try? Data(contentsOf: url) {
                cell.picture.image = UIImage(data: data)!
            } else {
           //TODO: default picture
            }
        }
        return cell
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            ApplicationManager.sharedInstance.start(queryTerm: searchText.text!)
            return false
        }
        let currentText: NSString = textView.text! as NSString
        let newText: NSString = currentText.replacingCharacters(in: range, with: text) as NSString
        return newText.length <= maxQueryLength
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func gotCurrentITunesEntity(data: [ITunesEntity]) {
        searchResultOfITunesEntity = data
        searchResult.reloadData()
    }
}

