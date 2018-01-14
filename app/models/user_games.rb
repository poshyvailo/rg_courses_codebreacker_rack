class UserGames

  def self.save(login, data)
    content = File.read(Setting::USER_GAMES_FILE)
    if content.match? /^#{login}:/
      data = Secret.new.encode(data)
      content = content.gsub /^(#{login}):[\s\S]+?---/, "#{login}:#{data}\n---"
    else
      content << "#{login}:#{Secret.new.encode(data)}\n---"
    end
    File.open(Setting::USER_GAMES_FILE, 'w') { |file| file.puts content }
  end

  def self.load(login)
    content = File.read(Setting::USER_GAMES_FILE)
    if content.match? /^#{login}:/
      data = content.match /^#{login}:([\s\S]+?)\n---/
      Secret.new.decode data[1].to_s
    end
  end
end