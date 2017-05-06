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
        cell.artistName.text = searchResultOfITunesEntity[indexPath.row].artistName
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            if let url = URL(string: self.searchResultOfITunesEntity[indexPath.row].image) {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.picture.image = UIImage(data: data)!
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.picture.image = UIImage(named: "defaultImage")
                    }
                }
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
    
//    private func showAlert(text: String, error: Error?) {
//        let alert = UIAlertController(title: "Oops", message: text, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        let action2 = UIAlertAction(title: "Try Again", style: .default, handler:
//            action in
//            
//            <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
//    }
}

