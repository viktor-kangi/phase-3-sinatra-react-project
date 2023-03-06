class ApplicationController < Sinatra::Base


  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  def json_response(code: 200, data: nil)
    status = [200, 201].include?(code) ? "SUCCESS" : "FAILED"
    headers['Content-Type'] = 'application/json'
    if data
      [ code, { data: data, message: status }.to_json ]
    end
  end

  def error_response(code, e)
    json_response(code: code, data: { error: e.message })
  end

  def erb_response(file)
    headers['Content-Type'] = 'text/html'
    erb file
  end

  def not_found_response
    json_response(code: 404, data: { error: "You seem lost. That route does not exist." })
  end

  not_found do
    not_found_response
  end


end

# class ApplicationController < Sinatra::Base
#     configure do
#       set :server, :puma
#       set :public_folder, 'public'
#       set :views, 'app/views'
#       use Rack::MethodOverride
#       use Rack::Session::Cookie, key: 'rack.session',
#                                  path: '/',
#                                 #  secret: Digest::SHA256.digest(ENV['SINATRA_SESSION_SECRET'])
#     #   register(Sinatra::JS)
#       register(Sinatra::Flash)
#     end

#     not_found do
#       flash[:error] = 'Error: Requested resource was not found'
#       redirect '/'
#     end

#     get '/' do
#       latest_count = [Meme.all.size, 9].min
#       @memes = Meme.last(latest_count)
#       erb :index
#     end

#     helpers do
#       def admin_password
#         ENV['SINATRA_ADMIN_PASSWORD']
#       end

#       def signed_in?
#         if session[:user_id]
#           true
#         else
#           false
#         end
#       end

#       def current_user
#         return unless session[:user_id]

#         User.find_by_id(session[:user_id])
#       end
#     end
#   end
