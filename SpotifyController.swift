//
//  SpotifyController.swift
//  https://github.com/benzguo/SpotifyController
//

import Foundation

enum SpotifyPlayerState : String {
    case Paused = "paused"
    case Playing = "playing"
    case Stopped = "stopped"
}

class SpotifyController {

    class func task(command: String) -> String? {
        let task = NSTask()
        let prefix = "tell application \"Spotify\" to"
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", "\(prefix) \(command)"]
        let outPipe = NSPipe()
        task.standardOutput = outPipe
        task.launch()
        task.waitUntilExit()
        let outHandle = outPipe.fileHandleForReading
        let output = NSString(data: outHandle.availableData, encoding: NSASCIIStringEncoding) as NSString?
        return output?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    class func trackInfoTask(command: String) -> String? {
        return task("\(command) of current track")
    }

// MARK: Composite commands
    class func setRepeating(repeating: Bool) {
        let maybeCurrent = isRepeating()
        if let current = maybeCurrent {
            if current == repeating { return }
            else { task("set repeating to not repeating") }
        }
    }

    class func setShuffling(shuffling: Bool) {
        let maybeCurrent = isShuffling()
        if let current = maybeCurrent {
            if current == shuffling { return }
            else { task("set shuffling to not shuffling") }
        }
    }

// MARK: Application Info
    /// Is repeating on or off?
    class func isRepeating() -> Bool? { return task("repeating")?.rangeOfString("true") != nil }

    /// Is shuffling on or off?
    class func isShuffling() -> Bool? { return task("shuffling")?.rangeOfString("true") != nil }

    /// The sound output volume (0 = minimum, 100 = maximum)
    class func volume() -> Int? { return task("sound volume")?.toInt() }

    /// The player's position within the currently playing track in seconds.
    /// Note: this doesn't appear to work on (1.0.3.101.gbfa97dfe)
    class func playerPosition() -> Float? {
        return task("player position").map { ($0 as NSString).floatValue }
    }

    /// Is Spotify stopped, paused, or playing?
    class func playerState() -> SpotifyPlayerState? {
        return task("player state").flatMap { SpotifyPlayerState(rawValue: $0) }
    }

// MARK: Track Info
    /// The URL of the track.
    class func currentTrackURL() -> String? { return trackInfoTask("spotify url") }

    /// The ID of the track.
    /// Note: same as URL
    class func currentTrackID() -> String? { return trackInfoTask("id") }

    /// The name of the track.
    class func currentTrackName() -> String? { return trackInfoTask("name") }

    /// The artist of the track.
    class func currentTrackArtist() -> String? { return trackInfoTask("artist") }

    /// The album of the track.
    class func currentTrackAlbum() -> String? { return trackInfoTask("album") }

    /// The track number of the track.
    class func currentTrackNumber() -> Int? { return trackInfoTask("track number")?.toInt() }

    /// The disc number of the track.
    class func currentTrackDiscNumber() -> Int? { return trackInfoTask("disc number")?.toInt() }

    /// The album artist of the track.
    class func currentTrackAlbumArtist() -> String? { return trackInfoTask("album artist") }

    /// The length of the track in seconds.
    class func currentTrackDuration() -> Int? { return trackInfoTask("duration")?.toInt() }

    /// The number of times this track has been played.
    /// Note: This appears to be the number of times the current user has played the track.
    class func currentTrackPlayCount() -> Int? { return trackInfoTask("played count")?.toInt() }

    /// How popular is this track? 0-100
    class func currentTrackPopularity() -> Int? { return trackInfoTask("popularity")?.toInt() }

    /// Is the track starred?
    class func currentTrackIsStarred() -> Bool? { return trackInfoTask("starred")?.rangeOfString("true") != nil }

// MARK: Commands
    /// Pause playback.
    class func pause() { task("pause") }

    /// Resume playback.
    class func play() { task("play") }

    /// Play the given spotify URL.
    class func play(spotifyURL: String) { task("play track \"\(spotifyURL)\"") }

    /// Skip to the next track.
    class func nextTrack() { task("next track") }

    /// Skip to the previous track.
    class func previousTrack() { task("previous track") }

// MARK: Standard app commands
    class func quit() { task("quit") }

    class func version() -> String? { return task("version") }

    class func frontmost() -> Bool? { return task("frontmost")?.rangeOfString("true") != nil }

}
