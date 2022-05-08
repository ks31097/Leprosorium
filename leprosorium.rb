require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb "Greeting you in Leprosorium!"
end

get '/new' do
  erb :new
end

post '/new' do
  @user_post = params[:content] # получить, то что отправил браузер со страницы new.erb <textarea name="content" class="form-control" placeholder="Type post text here" id="floatingTextarea2" style="height: 150px"></textarea>
  @message = 'Ваш пост отправлен!'

  erb "You typed: #{@user_post}"
end

get '/visit' do
  @title = "Записаться"
  erb :visit
end

post '/visit' do
        @user_name = params[:user_name] # получить, то что отправил браузер со страницы visit.erb <input name="user_name" type="text" class="form-control" placeholder="Введите Ваше имя">
        @user_phone = params[:user_phone] # получить, то что отправил браузер со страницы visit.erb <input name="user_phone" type="text" class="form-control" placeholder="Номер Вашего телефона">
        @date_time = params[:date_time] # получить, то что отправил браузер со страницы visit.erb <input name="date_time" type="text" class="form-control" placeholder="Введите дату и время">
        @master = params[:master] # получить, то что отправил браузер со страницы visit.erb <select name="master" class="form-select" aria-label="Default select example">
        @color = params[:color] # получить, то что отправил браузер со страницы visit.erb <select id="color" name="color">

        @title = 'Записаться'
        @info = 'Вы записались!'
        @message = "#{@user_name}, мы Вас ждем #{@date_time}. Ваш мастер #{@master}. Цвет окраски волос: #{@color}!"

        output = File.open('./public/visits.txt', 'a')
        output.write "User: #{@user_name}, Phone: #{@user_phone}, Date and time: #{@date_time}, master: #{@master}, color: #{@color}\n"
        output.close

        erb :message
end
