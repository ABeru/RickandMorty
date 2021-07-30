//
//  DetailsController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class DetailsController: UIViewController {
    @IBOutlet private weak var charImg: UIImageView!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var episodesColl: UICollectionView!
    var charDetail: CharactersM!
    private let epsViewModel = EpViewModel()
    private let filterVm = FilterVmChar()
    var episodesLinks = [String]()
    private var filtered = [CharactersM]()
    private var episodes = [EpisodeRes]()
    private var episodeIds = [Int]()
    private let autoCompView = LUAutocompleteView()
    private var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
     Assign()
    }
    private func Assign() {
        episodesColl.delegate = self
        episodesColl.dataSource = self
        autoCompView.textField = searchField
        autoCompView.delegate = self
        autoCompView.dataSource = self
        autoCompView.autocompleteCell = CustomAutocompleteTableViewCell.self
        autoCompView.rowHeight = 45
        autoCompView.maximumHeight = 300
        self.gender.text = charDetail.gender
        self.name.text = charDetail.name
        self.location.text = charDetail.location.name
        self.species.text = charDetail.species
        if charDetail.status != "Alive" {
            self.status.textColor = .red
        }
        else {
            self.status.textColor = .green
        }
        self.status.text = charDetail.status
        charDetail.image.downloadImage { (image) in
            DispatchQueue.main.async {
                self.charImg.image = image
            }
        }
      loadEpisodes()
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    private func loadEpisodes() {
        let lastChar = self.charDetail.episode[0].lastIndex(of: "/")
        let tempArr = self.charDetail.episode.map{$0.substring(from: lastChar!).dropFirst()}
        let tempArr2 = tempArr.map{Int($0)!}
        episodes.removeAll()
        if tempArr2.count == 1 {
            epsViewModel.fetchSingle(tempArr2[0]) { (result) in
                self.episodes.append(result)
                DispatchQueue.main.async {
                    self.episodesColl.reloadData()
                }
            }
        } else {
        epsViewModel.fetch(tempArr2) { (result) in
            self.episodes.append(contentsOf: result)
            DispatchQueue.main.async {
                self.episodesColl.reloadData()
            }
        }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            let lastchar2 = self.episodes[0].characters[0].lastIndex(of: "/")
            let charIds = self.episodes.map{$0.characters.map{$0.substring(from: lastchar2!).dropFirst()}}
            CharVc.episode = self.episodes[selectedIndex]
           CharVc.charIds = charIds[selectedIndex].map{Int($0)!}
        }
}
    @IBAction private func searchText(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            filterVm.fetch(sender.text!) { (result) in
                self.filtered.removeAll()
                self.filtered.append(contentsOf: result.results)
            }
        }
        else {
            self.filtered.removeAll()
        }
    }
}
extension DetailsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "charGo", sender: nil)
    }
    
}
extension DetailsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailsCell
        cell.name.text = episodes[indexPath.row].name
        cell.airDate.text = episodes[indexPath.row].airDate
        cell.episode.text = episodes[indexPath.row].episode
        return cell
        
    }
    
    
}
extension DetailsController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = filtered.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension DetailsController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        selectedIndex = filtered.firstIndex(where: {$0.name == text})!
        charDetail = filtered[selectedIndex]
        episodes.removeAll()
        Assign()
        print(text + " was selected from autocomplete view")
      
    }
}
