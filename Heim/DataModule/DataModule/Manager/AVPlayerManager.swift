//
//  AVPlayerManager.swift
//  DataModule
//
//  Created by 정지용 on 11/26/24.
//

import AVFoundation
import Domain
import MusicKit

final class AVPlayerManager {
  // MARK: - Properties
  private var player: AVPlayer?
  private var playerItem: AVPlayerItem?
  private var timeObserver: Any?

  var isPlaying: Bool {
    return player?.timeControlStatus == .playing
  }

  // MARK: - Initialization
  init() {}

  deinit {
    if let timeObserver = timeObserver {
      player?.removeTimeObserver(timeObserver)
    }
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Public Methods
  func play(url: URL) async {
    // 기존 플레이어 정리
    cleanup()

    playerItem = AVPlayerItem(url: url)
    player = AVPlayer(playerItem: playerItem)

    // 볼륨 초기값 설정
    player?.volume = 1.0

    // 재생 완료 알림 등록
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(playerDidFinishPlaying),
      name: .AVPlayerItemDidPlayToEndTime,
      object: playerItem
    )

    // 재생 시작
    await player?.play()
  }

  func pause() {
    player?.pause()
  }

  func setVolume(_ volume: Float) {
    player?.volume = max(0.0, min(1.0, volume))
  }

  func setupAudioSession() throws {
    do {
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      throw MusicError.playingError
    }
  }

  // MARK: - Private Methods
  private func cleanup() {
    player?.pause()
    if let timeObserver = timeObserver {
      player?.removeTimeObserver(timeObserver)
      self.timeObserver = nil
    }
    playerItem = nil
    player = nil
  }

  @objc
  private func playerDidFinishPlaying(notification: NSNotification) {
    cleanup()
  }
}
