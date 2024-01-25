import UIKit

final class InfoViewController: UIViewController {
    
    private var residents: [Resident] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var residentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizesSubviews = true
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "resident")
        return tableView
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("To see".localized, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Info".localized
        view.backgroundColor = .systemMint
        view.addSubviews(actionButton, titleLabel, orbitalPeriodLabel, residentsTableView)
        setupContraints()
        actionButton.addTarget(self, action: #selector(alertViewController(_:)), for: .touchUpInside)
        setTitle()
        getInfo()
    }
    
    private func setupContraints(){
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            residentsTableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 16),
            residentsTableView.leadingAnchor.constraint(equalTo: orbitalPeriodLabel.leadingAnchor),
            residentsTableView.trailingAnchor.constraint(equalTo: orbitalPeriodLabel.trailingAnchor),
            residentsTableView.heightAnchor.constraint(equalToConstant: 350),
            
            actionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 20.0),
            actionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -20.0),
            actionButton.topAnchor.constraint(equalTo: residentsTableView.bottomAnchor, constant: 16),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    private func setTitle() {
        let url = SomeTitleFromNetwork().url
        NetworkService.request(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    self?.titleLabel.text = title
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getInfo(){
        getInfoAboutPlanet { [ weak self] result in
            
            switch result {
            case .success(let planet):
                DispatchQueue.main.async {
                    self?.orbitalPeriodLabel.text = "The period of the planet Tatooine's revolution around its star".localized + ": \(planet.orbitalPeriod)"
                }
                planet.residents.forEach { resident in
                    self?.getInfoAboutResident(resident: resident) { resultResident in
                        switch resultResident {
                        case .success(let resident):
                            self?.residents.append(resident)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        DispatchQueue.main.async {
                            self?.residentsTableView.reloadData()
                        }

                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getInfoAboutPlanet(completion: @escaping (Result<Planets,NetworkError>) -> Void){
        guard let url = PlanetFromNetwork.planet.url else {return}
        NetworkService.fetchData(request: URLRequest(url: url), completion: completion)
    }
    
    private func getInfoAboutResident(resident: String, completion: @escaping (Result<Resident,NetworkError>) -> Void){
        guard let url = URL(string: resident) else {return}
        NetworkService.fetchData(request: URLRequest(url: url), completion: completion)
    }
    
    @objc func alertViewController(_ sender: UIAlertController) {
        let alertController = UIAlertController(title: "Information first".localized, message: "The second information, the message".localized, preferredStyle: .alert)
        
        let actionFirstName = "Left".localized
        let actionSecondName = "Right".localized

        let actionFirst = UIAlertAction(title: actionFirstName, style: .default, handler: { action in
            print("Pressed the button".localized + " \(actionFirstName)")
        })
        let actionSecond = UIAlertAction(title: actionSecondName, style: .default, handler: { action in
            print("Pressed the button".localized + " \(actionSecondName)")
        })
        
        alertController.addAction(actionFirst)
        alertController.addAction(actionSecond)
        self.present(alertController, animated: true)
        }
}

extension InfoViewController: UITableViewDelegate {}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resident", for: indexPath) as! InfoTableViewCell
        cell.update(model: residents[indexPath.row])
        return cell
    }
}
