class Admin::BaseController < ApplicationController
  require "digest/sha2"
  layout 'admin'
  
  requires_authentication :using => :authenticate
  
  private
    def authenticate(username, password)
      salt = "+ppn4SV+"
      return username == 'guylaine' && Digest::SHA256.hexdigest(password + salt)== "f3975f2a3a52a2db56d074c124b984d81282dd8bdc12655ed7d08c7f29a41635"
    end
    
end