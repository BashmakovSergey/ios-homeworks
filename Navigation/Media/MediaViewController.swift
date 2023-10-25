import UIKit
import AVFoundation
import AVKit

class MediaViewController: UIViewController {
    
    let coordinator: FeedCoordinator
    private var player = AVAudioPlayer()
    private var viewModel = MediaModel()
    private var currentSong = 0
    private var currentVideo = 0
    private var isPlaying: Bool
    private let videosTableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var buttomVoiceRecorderAction: (() -> Void) = {
        self.coordinator.presentVoiceRecorder(navigationController: self.navigationController)
    }
    
    let backButton: UIBarButtonItem = {
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        return backButton
    }()
    
    private let trackNameLabel: UILabel = {
        let songNameLabel = UILabel()
        songNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        songNameLabel.numberOfLines = 0
        songNameLabel.textColor = .black
        songNameLabel.backgroundColor = .systemGray3
        songNameLabel.textAlignment = .center
        songNameLabel.text = "Имя песни"
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return songNameLabel
    }()
    
    private lazy var playPausaTrackButton: UIButton = {
        let playPausaButton = UIButton()
        playPausaButton.contentMode = .scaleToFill
        playPausaButton.tintColor = .black
        playPausaButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
        playPausaButton.addTarget(nil, action: #selector(tapOnPlayPausaButton), for: .touchUpInside)
        playPausaButton.translatesAutoresizingMaskIntoConstraints = false
        return playPausaButton
    }()
    
    private lazy var secretHidenButton: UIButton = {
        let hidenButton = UIButton()
        hidenButton.translatesAutoresizingMaskIntoConstraints = false
        return hidenButton
    }()
    
    private lazy var stopTrackButton: UIButton = {
        let stopButton = UIButton()
        stopButton.contentMode = .scaleToFill
        stopButton.tintColor = .black
        stopButton.setImage(UIImage.init(systemName: "stop.fill"), for: .normal)
        stopButton.addTarget(nil, action: #selector(tapOnStopButton), for: .touchUpInside)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        return stopButton
    }()
    
    private lazy var previousTrackButton: UIButton = {
        let previousTrackButton = UIButton()
        previousTrackButton.contentMode = .scaleToFill
        previousTrackButton.tintColor = .black
        previousTrackButton.setImage(UIImage.init(systemName: "backward.end.alt.fill"), for: .normal)
        previousTrackButton.addTarget(nil, action: #selector(tapOnPrevSongButton), for: .touchUpInside)
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        return previousTrackButton
    }()
    
    private var nextTrackButton: UIButton = {
        let nextTrackButton = UIButton()
        nextTrackButton.contentMode = .scaleToFill
        nextTrackButton.tintColor = .black
        nextTrackButton.setImage(UIImage.init(systemName: "forward.end.alt.fill"), for: .normal)
        nextTrackButton.addTarget(nil, action: #selector(tapOnNextSongButton), for: .touchUpInside)
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        return nextTrackButton
    }()
    
    private lazy var voiceRecorderButton: CustomButton = {
        let voiceRecorderButton = CustomButton(titleText: "Диктофон", titleColor: .red, backgroundColor: .gray, tapAction: buttomVoiceRecorderAction)
        return voiceRecorderButton
    }()
    
    init(coordinator: FeedCoordinator){
        self.isPlaying = false
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        view.addSubviews(secretHidenButton, playPausaTrackButton, stopTrackButton, previousTrackButton, nextTrackButton, trackNameLabel, videosTableView, voiceRecorderButton)
        prepareTrack()
        setupConstraints()
        setupTableView()
    }
    
    private func setupTableView() {
        videosTableView.register(VideosTableViewCell.self, forCellReuseIdentifier: String(describing: VideosTableViewCell.self))
        videosTableView.translatesAutoresizingMaskIntoConstraints = false
        videosTableView.dataSource = self
        videosTableView.delegate = self
    }
    
    private func prepareTrack() {
        
        guard let musicUrl = Bundle.main.url(forResource: viewModel.songsURLs[currentSong], withExtension: "mp3") else { return }
        
        do {
            try player = AVAudioPlayer(contentsOf: musicUrl)
            player.prepareToPlay()
            trackNameLabel.text = viewModel.songsURLs[currentSong]
        } catch {
            print(mediaError.musicError)
        }
    }
    
    @objc private func tapOnPlayPausaButton(){
        if !isPlaying {
            player.play()
            isPlaying = true
            playPausaTrackButton.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
        } else {
            player.stop()
            playPausaTrackButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
            isPlaying = false
        }
    }
    
    @objc private func tapOnStopButton() {
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
            playPausaTrackButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
            isPlaying = false
        }
        else {
            player.currentTime = 0
        }
    }
    
    @objc private func tapOnNextSongButton() {
        player.stop()
        playPausaTrackButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
        isPlaying = false
        currentSong += 1
        if currentSong == viewModel.countSong {
            currentSong = 0
        }
        prepareTrack()
        print(currentSong)
    }
    
    @objc private func tapOnPrevSongButton() {
        player.stop()
        playPausaTrackButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
        isPlaying = false
        currentSong -= 1
        if currentSong == -1 {
            currentSong = viewModel.countSong-1
        }
        prepareTrack()
        print(currentSong)
    }
    
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                videosTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                videosTableView.heightAnchor.constraint(equalToConstant: 250),
                videosTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                videosTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                
                voiceRecorderButton.centerXAnchor.constraint(equalTo: videosTableView.centerXAnchor),
                voiceRecorderButton.topAnchor.constraint(equalTo: videosTableView.bottomAnchor, constant: 25),
                voiceRecorderButton.heightAnchor.constraint(equalToConstant: 50),
                voiceRecorderButton.widthAnchor.constraint(equalToConstant: 250),
                
                trackNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                trackNameLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 150),
                trackNameLabel.heightAnchor.constraint(equalToConstant: 50),
                trackNameLabel.widthAnchor.constraint(equalToConstant: 100),
                
                secretHidenButton.centerXAnchor.constraint(equalTo: trackNameLabel.centerXAnchor),
                secretHidenButton.centerYAnchor.constraint(equalTo: trackNameLabel.centerYAnchor, constant: 75),
                secretHidenButton.heightAnchor.constraint(equalToConstant: 60),
                secretHidenButton.widthAnchor.constraint(equalToConstant: 60),
                
                playPausaTrackButton.centerXAnchor.constraint(equalTo: secretHidenButton.centerXAnchor, constant: -30),
                playPausaTrackButton.centerYAnchor.constraint(equalTo: secretHidenButton.centerYAnchor),
                playPausaTrackButton.heightAnchor.constraint(equalToConstant: 60),
                playPausaTrackButton.widthAnchor.constraint(equalToConstant: 60),
                
                stopTrackButton.centerXAnchor.constraint(equalTo: secretHidenButton.centerXAnchor, constant: 30),
                stopTrackButton.centerYAnchor.constraint(equalTo: secretHidenButton.centerYAnchor),
                stopTrackButton.heightAnchor.constraint(equalToConstant: 60),
                stopTrackButton.widthAnchor.constraint(equalToConstant: 60),
                
                previousTrackButton.centerXAnchor.constraint(equalTo: playPausaTrackButton.centerXAnchor, constant: -60),
                previousTrackButton.centerYAnchor.constraint(equalTo: playPausaTrackButton.centerYAnchor),
                previousTrackButton.heightAnchor.constraint(equalToConstant: 60),
                previousTrackButton.widthAnchor.constraint(equalToConstant: 60),
                
                nextTrackButton.centerXAnchor.constraint(equalTo: stopTrackButton.centerXAnchor, constant: 60),
                nextTrackButton.centerYAnchor.constraint(equalTo: playPausaTrackButton.centerYAnchor),
                nextTrackButton.heightAnchor.constraint(equalToConstant: 60),
                nextTrackButton.widthAnchor.constraint(equalToConstant: 60),
            ])
        }
        
}


extension MediaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.videosURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videosTableViewCell = tableView.dequeueReusableCell(withIdentifier:  String(describing: VideosTableViewCell.self), for: indexPath) as! VideosTableViewCell
        videosTableViewCell.update(model: viewModel.videosURLs[indexPath.item])
        return videosTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videoPath = Bundle.main.path(forResource: viewModel.videosURLs[indexPath.row], ofType: "mp4") else {
            print(mediaError.musicError)
            return
        }
        let videoUrl = URL(fileURLWithPath: videoPath)
        let player = AVPlayer(url: videoUrl)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsTimecodes = true
        present(controller, animated: true) {
            player.play()
        }
    }
    
}
