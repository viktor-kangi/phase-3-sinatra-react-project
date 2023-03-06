class MemeController < ApplicationController
  set :default_content_type, 'application/json'
  set :views, './app/views'

  
  get '/home' do
      "Welcome To the meme app"
  end

   
  post '/memes/create' do
    # puts params.inspect
    data = JSON.parse(request.body.read)
      begin
          memes = Meme.create(data)
          json_response(code: 201, data: memes)
          memes.to_json
      rescue => e
          json_response(code: 422, data: { error: e.message })
        #   memes.to_json
      end       
    end
  
   
  get '/memes' do
      memes = Meme.all
      memes.to_json
  end

  # @view: Renders an erb file which shows all TODOs
  # erb has content_type because we want to override the default set above
  # get '/' do
  #     @todos = Todo.all.map { |todo|
  #       {
  #         todo: todo,
  #         badge: todo_status_badge(todo.status)
  #       }
  #     }
  #     @i = 1
  #     erb_response :todos
  # end

   
  put '/memes/update/:id' do
    data = JSON.parse(request.body.read)
      begin
          memes = Meme.find(params[:id].to_i)
          memes.update(data)
          json_response(data: { message: "memes updated successfully" })
          memes.to_json
      rescue => e
          json_response(code: 422 ,data: { error: e.message })
      end
  end

   get '/memes/search' do
    query = params[:query]
    memes = Meme.select{ |meme| meme[:title].include?(query) || meme[:date].to_s.include?(query) }
    memes.to_json
      end
   
      delete '/memes/:id' do
        begin
          meme = Meme.find(params[:id])
          meme.destroy
          json_response(data: { message: "Meme deleted successfully" })
          meme.to_json
        rescue => e
          json_response(code: 422, data: { error: e.message })
           
        end
      end
      
      

  private

   
  def data(create: false)
      payload = JSON.parse(request.body.read)
      if create
          payload["createdAt"] = Time.now
      end
      payload
  end

   
  def memes_id
      params['id'].to_i
  end

   
  def memes_status_badge(status)
      case status
          when 'CREATED'
              'bg-info'
          when 'ONGOING'
              'bg-success'
          when 'CANCELLED'
              'bg-primary'
          when 'COMPLETED'
              'bg-warning'
          else
              'bg-dark'
      end
  end

  
 
end