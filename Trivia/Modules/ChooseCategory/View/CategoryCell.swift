import UIKit

final class CategoryCell: UITableViewCell {
	// MARK: - Initializers
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = UITableViewCell.SelectionStyle.none
		contentView.backgroundColor = ColorPalette.Primary.Light.background
		
		textLabel?.textColor = ColorPalette.Primary.Light.text
		textLabel?.numberOfLines = 0
	}
}
