import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    private var searchResultOfITunesEntity: [ITunesEntity] = []
    
    @IBOutlet weak var searchText: UITextView!
    @IBOutlet weak var searchResult: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchText.text = ""
        searchText.layer.borderColor = UIConstant.borderColorOfTextView.cgColor
        searchText.layer.borderWidth = UIConstant.borderWidthOFTextView
        searchResult.delegate = self
        searchResult.dataSource = self
        ApplicationManager.sharedInstance.gotCurrentITunesEntity = gotCurrentITunesEntity
        ApplicationManager.sharedInstance.gotError = showAlert
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
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
        return newText.length <= UIConstant.maxQueryLength
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
        var actions: [UIAlertAction] = [UIAlertAction(title: UIConstant.okALertAction, style: .default, handler: nil)]
        
        switch error {
        case APIError.noInternetConnection:
            messageError = UIConstant.noInternetMessage
            actions.append(UIAlertAction(title: UIConstant.tryAgainAlertAction, style: .default, handler: {
                action in
                ApplicationManager.sharedInstance.start(queryTerm: self.searchText.text!)
            }))
        case JSONParsingError.invalidJSON:
            messageError = UIConstant.invalidJSONMessage
        case JSONParsingError.unexpectedJSONContent:
            messageError = UIConstant.unexpectedJSONContentMessage
        default:
            messageError = "\(error.localizedDescription)"
        }
        let alert = UIAlertController(title: UIConstant.titleAlert, message: messageError, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

