class Spotify
  def initialize
    RSpotify.authenticate('bf0685096684417f88741fa4bd765ffc', 'c4ff078bdeba4268a09ceac8b4be18f4')
  end

  def playlist(user_id, playlist_id)
    RSpotify::Playlist.find(user_id, playlist_id).tracks.map do |track|
      "#{track.name} - #{track.album.name} - #{track.artists.first.name}"
    end
  end
end
