import UIKit

class CellITunesEntity: UITableViewCell {

    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var artistName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
