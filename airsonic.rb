class Airsonic
  attr_writer :user, :password, :url

  def initialize
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

  def find_songs(songs)
    endpoint = @url + 'search3'
    params = @base_params.clone.tap do |bp|
      bp[:params][:t] = token
    end

    # TODO: Get all library here and then parse it
    response = RestClient.get(endpoint, params)
    parsed_body = Ox.parse(response.body)
    library = parsed_body.nodes.first.nodes.first.nodes

    return if library.empty?

    song_list = []

    songs.each do |song|
      selected = library.select do |element|
        element.attributes[:artist].casecmp(song[:artist]) &&
          element.attributes[:album].casecmp(song[:album]) &&
          element.attributes[:title].casecmp(song[:name]) # Darude sandstorm?
      end

      song_list << selected.first.attributes if selected.any?
    end

    song_list
  end

  private

  def token
    Digest::MD5.hexdigest(@password + Random.rand.to_s)
  end
end
