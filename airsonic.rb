class Airsonic
  def initialize
    @user = 'user'
    @password = 'password'
    @url = 'url_of_your_server/rest/'
    @base_params = { params: { u: @user, p: @password, s: @salt, v: "1.15.0", c: 'spotysonic' } }
  end

  def create_playlist(song_ids)
    endpoint = @url + 'createPlaylist'
    params = @base_params.clone.tap do |bp|
      bp[:params][:t] = token
      bp[:params][:name] = "Playlist name"
      bp[:params][:songId] = songs_ids
    end

    RestClient.get(endpoint, params)
  end

  def find_song(artist, album, name)
    endpoint = @url + 'search3'
    params = @base_params.clone.tap do |bp|
      bp[:params][:t] = token
      bp[:params][:query] = "#{artist} #{album} #{name}"
      bp[:params][:artistCount] = 0
      bp[:params][:albumCount] = 0
    end

    response = RestClient.get(endpoint, params)
    parsed_body = Ox.parse(response.body)
    songs = parsed_body.nodes.first.nodes.first.nodes

    return if songs.empty?

    songs.select do |song|
      song.attributes[:artist].casecmp(artist) &&
        song.attributes[:album].casecmp(album) &&
        song.attributes[:title].casecmp(name)
    end.first.attributes
  end

  private

  def token
    Digest::MD5.hexdigest(@password + Random.rand.to_s)
  end
end
