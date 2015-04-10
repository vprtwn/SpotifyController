# SpotifyController

Swift interface to the commands defined in the Spotify app's scripting definition file: [`/Applications/Spotify.app/Contents/Resources/Spotify.sdef`](https://gist.github.com/benzguo/88e81793b1295537ef80)

### Examples
```Swift
SpotifyController.setRepeating(true)
SpotifyController.setShuffling(false)
SpotifyController.nextTrack()
SpotifyController.previousTrack()
SpotifyController.pause()
SpotifyController.play()
```

### References
* [Apple – Cocoa Scripting Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptableCocoaApplications/SApps_intro/SAppsIntro.html#//apple_ref/doc/uid/TP40002164)
