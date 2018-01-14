# frozen_string_literal: true

# UserGames class
class UserGames
  def self.save(login, data)
    content = File.read(Setting::USER_GAMES_FILE)
    data = "#{login}:#{Crypto.new.encode(data)}\n---"
    if content.match?(/^#{login}:/)
      content = content.gsub(/^(#{login}):[\s\S]+?---/, data)
    else
      content << data
    end
    File.open(Setting::USER_GAMES_FILE, 'w') { |file| file.puts content }
  end

  def self.load(login)
    content = File.read(Setting::USER_GAMES_FILE)
    return unless content.match?(/^#{login}:/)
    data = content.match(/^#{login}:([\s\S]+?)\n---/)
    Crypto.new.decode data[1].to_s
  end
end