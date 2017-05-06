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
        ApplicationManager.sharedInstance.gotError = showAlert
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
    
    private func showAlert(error: Error) {
        var messageError = ""
        var actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)]
        switch error {
        case ErrorType.noInternetConnection:
            messageError = "No internet connection"
            actions.append(UIAlertAction(title: "Try Again", style: .default, handler: {
                action in
                ApplicationManager.sharedInstance.start(queryTerm: self.searchText.text!)
            }))
        case ErrorType.invalidJSON:
            messageError = "Invalid JSON"
        case ErrorType.unexpectedJSONContent:
            messageError = "Unexpected JSON content"
        default:
            messageError = "\(error.localizedDescription)"
        }
        let alert = UIAlertController(title: "Oops!", message: messageError, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

