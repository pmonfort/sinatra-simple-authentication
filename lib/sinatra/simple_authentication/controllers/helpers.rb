# -*- coding: utf-8 -*-

module Sinatra
  module SimpleAuthentication
    module Controllers
      module Helpers
        def hash_to_query_string(hash)
          hash.collect {|k,v| "#{k}=#{v}"}.join('&')
        end

        def login_required
          if !!current_user
            return true
          else
            session[:return_to] = request.fullpath
            redirect '/login'
            return false
          end
        end

        def current_user
          if !!session[:user]
            Session.model_class.first(:id => session[:user])
          else
            return false
          end
        end

        def logged_in?
          !!session[:user]
        end

        #BECAUSE sinatra 9.1.1 can't load views from different paths properly
        def get_view_as_string(filename)
          view = File.join(settings.sinatra_authentication_view_path, filename)
          data = ""
          f = File.open(view, "r")
          f.each_line do |line|
            data += line
          end
          return data
        end
      end
    end
  end
end
