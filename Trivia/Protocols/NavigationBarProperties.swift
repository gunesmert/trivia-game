import Foundation

protocol NavigationBarProperties {
	var shouldShowNavigationBar: Bool { get }
	var shouldShowLargeNavigationBar: Bool { get }
	var shouldShowShadowUnderNavigationBar: Bool { get }
	var leftNavigationItemBundles: [NavigationItemBundle] { get }
	var rightNavigationItemBundles: [NavigationItemBundle] { get }
}

extension NavigationBarProperties {
	var shouldShowNavigationBar: Bool { return true }
	var shouldShowLargeNavigationBar: Bool { return true }
	var shouldShowShadowUnderNavigationBar: Bool { return true }
	var leftNavigationItemBundles: [NavigationItemBundle] { return [] }
	var rightNavigationItemBundles: [NavigationItemBundle] { return [] }
}
