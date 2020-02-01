import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var collectionView: NSCollectionView!
	private var configurationOne = true

	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.register(NSNib(nibNamed: "CollectionViewItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier("reuseIdentifier"))
	}

	@IBAction func switchToConfigurationTwo(_ sender: AnyObject?) {
		guard configurationOne else {
			return
		}

		// Update the model before the UI
		configurationOne = false

		collectionView.animator().performBatchUpdates({
			collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
			collectionView.moveSection(0, toSection: 1)
			collectionView.moveItem(at: IndexPath(item: 0, section: 1), to: IndexPath(item: 0, section: 0))

		})
	}
}

// Configuration 1 (2 sections, 3 items): [[I: A,B],[II: C]]
// Configuration 2 (2 sections, 2 items): [[II: C],[I: B]]
extension ViewController: NSCollectionViewDataSource {
	func numberOfSections(in collectionView: NSCollectionView) -> Int {
		return 2
	}

	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		if configurationOne {
			switch section {
			case 0: return 2
			case 1: return 1
			default: preconditionFailure()
			}
		}
		else {
			switch section {
			case 0: return 1
			case 1: return 1
			default: preconditionFailure()
			}
		}
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("reuseIdentifier"), for: indexPath)
		item.textField?.stringValue = indexPath.debugDescription
		return item
	}
}
