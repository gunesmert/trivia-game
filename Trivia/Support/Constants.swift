import UIKit

public struct Constants {
	public static var defaultMargin: CGFloat = 16.0
	public static var defaultCornerRadius: CGFloat = 8.0
	public static var defaultSpacing: CGFloat = UIDevice.hasSmallScreenSize ? 12.0 : 16.0
	public static var minimumDimension: CGFloat = UIDevice.hasSmallScreenSize ? 44.0 : 62.0
	public static var defaultQuestionCountOfAGame: Int = 10
}
