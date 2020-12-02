class DiscordApiService
  BOT_TOKEN = 'Bot ' + ENV['EXALTED_DISCORD_BOT_TOKEN']

  def self.username(discord_uid)
    user = JSON.parse get("users/#{discord_uid}")
    "#{user['username']}##{user['discriminator']}"
  end

  ##
  # Internals
  def self.get(endpoint)
    uri = api_url(endpoint)
    request = Net::HTTP::Get.new(uri)
    set_headers(request)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    return '{}' unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  def self.api_url(endpoint)
    URI.join('https://discord.com/api/', endpoint)
  end

  def self.set_headers(request)
    request['Authorization'] = BOT_TOKEN
    request['User-Agent'] = 'DiscordBot (https://localhost:3000, v0.1)'
  end
end
