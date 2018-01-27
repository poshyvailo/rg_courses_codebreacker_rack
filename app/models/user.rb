# frozen_string_literal: true

# User class
class User
  attr_accessor :name
  attr_reader :password_hash, :login

  def password_hash=(password)
    @password_hash = md5 password
  end

  def login=(login)
    @login = login.downcase
  end

  def save
    File.open(Setting::USERS_FILE, 'a+') do |file|
      file.puts "#{@login}:#{@name}:#{@password_hash}"
    end
    self
  end

  def load_user(login)
    return if login.nil?
    current_user = all_users.find { |user| user[:login] == login.downcase }
    return if current_user.nil?
    @login = current_user[:login]
    @name = current_user[:name]
    @password_hash = current_user[:password_hash]
    UserGames.load @login
    self
  end

  def password_equal?(password)
    return false if password.nil?
    @password_hash == md5(password)
  end

  private

  def all_users
    users = []
    File.open(Setting::USERS_FILE).each_line do |line|
      login, name, password_hash = line.chomp.split(':')
      users.push(login: login, name: name, password_hash: password_hash)
    end
    users
  end

  def md5(string)
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(string))
  end
end