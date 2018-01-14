# frozen_string_literal: true

# class Crypto
class Crypto
  def encode(str)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = ENV['SECRET_KEY']
    cipher.iv = ENV['SECRET_IV']
    str = Marshal.dump str
    str = cipher.update(str) + cipher.final
    Base64.encode64 str
  end

  def decode(str)
    return unless str
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.key = ENV['SECRET_KEY']
    decipher.iv = ENV['SECRET_IV']
    str = Base64.decode64 str
    str = decipher.update(str) + decipher.final
    Marshal.load str
  end
end