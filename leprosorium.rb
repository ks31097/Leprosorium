require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'sinatra/reloader'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

configure do
  
end

before do
  init_db
end

get '/' do
  erb "Greeting you in Leprosorium!"
end

get '/new' do
  erb :new
end

post '/new' do
  @user_post = params[:content] # получить, то что отправил браузер со страницы new.erb <textarea name="content" class="form-control" placeholder="Type post text here" id="floatingTextarea2" style="height: 150px"></textarea>

  erb "You typed: #{@user_post}"
end
