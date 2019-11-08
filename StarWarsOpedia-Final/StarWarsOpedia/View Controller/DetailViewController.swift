/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var item1TitleLabel: UILabel!
  @IBOutlet weak var item1Label: UILabel!
  @IBOutlet weak var item2TitleLabel: UILabel!
  @IBOutlet weak var item2Label: UILabel!
  @IBOutlet weak var item3TitleLabel: UILabel!
  @IBOutlet weak var item3Label: UILabel!
  @IBOutlet weak var listTitleLabel: UILabel!
  @IBOutlet weak var listTableView: UITableView!
  
  var data: Any!
  var listData: [Any] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    commonInit()
    
    listTableView.dataSource = self
    
    if let film = data as? Film {
      titleLabel.text = film.title
      subtitleLabel.text = "Episode \(String(film.id))"
      item1Label.text = film.director
      item2Label.text = film.producer
      item3Label.text = film.releaseDate
      fetchStarships()
    } else if let starship = data as? Starship {
      titleLabel.text = starship.name
      subtitleLabel.text = starship.model
      item1Label.text = starship.manufacturer
      item2Label.text = starship.starshipClass
      item3Label.text = starship.hyperdriveRating
      fetchFilms()
    }
  }
  
  func commonInit() {
    if let _ = data as? Starship {
      item1TitleLabel.text = "MANUFACTURER"
      item2TitleLabel.text = "CLASS"
      item3TitleLabel.text = "HYPERDRIVE RATING"
      listTitleLabel.text = "FILMS"
    } else {
      item1TitleLabel.text = "DIRECTOR"
      item2TitleLabel.text = "PRODUCER"
      item3TitleLabel.text = "RELEASE DATE"
      listTitleLabel.text = "STARSHIPS"
    }
  }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
    if let starship = listData[indexPath.row] as? Starship {
      cell.textLabel?.text = starship.name
    } else if let film = listData[indexPath.row] as? Film {
      cell.textLabel?.text = film.title
    }
    return cell
  }
}

// MARK: - SWAPI
extension DetailViewController {
  func fetchStarships() {
    guard let film = data as? Film else { return }
    SWAPI.fetchStarships(fromFilm: film, completionHandler: { [weak self] (starships) in
      self?.listData = starships ?? [Starship]()
      self?.listTableView.reloadData()
    })
  }
  
  func fetchFilms() {
    guard let starship = data as? Starship else { return }
    SWAPI.fetchFilms(fromStarship: starship, completionHandler: { [weak self] (films) in
      self?.listData = films ?? [Film]()
      self?.listTableView.reloadData()
    })
  }
}
