def set_user(user)
  airsonic_instance.user = user
end

def set_password(password)
  airsonic_instance.password = password
end

def set_url(url)
  airsonic_instance.url = url
end

def add_playlist(playlist)
  user_id = playlist.split(':')[2]
  playlist_id = playlist.split(':')[4]

  playlists << { user_id => playlist_id }
end

private

def airsonic_instance
  @airsonic_instance ||= Airsonic.new
end

def playlists
  @playlists ||= []
end
