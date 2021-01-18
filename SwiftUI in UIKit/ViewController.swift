//
//  ViewController.swift
//  SwiftUI in UIKit
//
//  Created by Kouki Saito on 2021/01/18.
//

import SwiftUI

let text = "1234567890"

final class SwiftUICell<Content: View>: UICollectionViewCell {
    private var hostingController = UIHostingController<Content?>(rootView: nil)

    func render(rootView: Content, parentViewController: UIViewController) {
        hostingController.willMove(toParent: nil)
        hostingController.removeFromParent()
        hostingController.view.removeFromSuperview()

        hostingController = UIHostingController<Content?>(rootView: rootView)

        parentViewController.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
        ])

        hostingController.didMove(toParent: parentViewController)
    }
}

struct ContentViewOfCell: View {
    @State
    var text: String = ""
    var body: some View {
        Text(text)
            .padding()
    }
}

class ViewController: UICollectionViewController {

    let cellRegistration = UICollectionView.CellRegistration<SwiftUICell<ContentViewOfCell>, String> { (cell, indexPath, item) in
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.setCollectionViewLayout(createLayout(), animated: false)

    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { (section, environment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)

            return section
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: String(indexPath.row))
        cell.render(rootView: ContentViewOfCell(text:
            String(indexPath.row) + "\n" + String(repeating: text, count: indexPath.row)
        ), parentViewController: self)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
}


struct ImageContentViewOfCell: View {
    let images = [
        "ipad.homebutton",
        "ipad",
        "iphone",
        "iphone.radiowaves.left.and.right",
        "laptopcomputer.and.iphone",
        "macmini.fill",
        "photo"
    ]
    var body: some View {
        ZStack {
            Image(systemName: images.randomElement()!)
                .resizable()
                .aspectRatio(9/16, contentMode: .fit)
            Text("iPad")
        }
        .padding()
    }
}

class ImageViewController: UICollectionViewController {

    let cellRegistration = UICollectionView.CellRegistration<SwiftUICell<ImageContentViewOfCell>, String> { (cell, indexPath, item) in
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { (section, environment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 3)
            let section = NSCollectionLayoutSection(group: group)

            return section
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: String(indexPath.row))
        cell.render(rootView: ImageContentViewOfCell(), parentViewController: self)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
}
