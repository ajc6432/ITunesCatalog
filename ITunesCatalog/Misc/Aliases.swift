import Foundation
import UIKit

// MARK: Results
typealias HTTPResult = Result <Data, Error>
typealias JSONResult = Result<Data, Error>
typealias MediaCatalogResult = Result<MediaCatalog, Error>

// MARK: Callbacks
typealias HTTPCallback = (HTTPResult) -> Void
typealias AlertCallback = ((UIAlertAction) -> Void)
typealias AlertActionHandler = (UIAlertAction) -> Void
