require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'sinatra/reloader'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

# метод before выполняется каждый раз перед выполнением любого запроса
# например при перезагрузки любой страницы
before do
# инициализация БД
  init_db
end
# метод configure вызывается каждый раз при конфигурации приложения:
# когда изменился код программы / перезагрузилась страница
configure do
# инициализация БД
# метод init_db не исполняется при конфигурации, что приводит к ошибке
  init_db
# создаем таблицу если таблица не существует
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
  (
	   id	INTEGER, created date	DATE,
     content	TEXT, PRIMARY KEY(id AUTOINCREMENT)
  );'

end

get '/' do
  # выбрать список постов из БД
  # 'select * from Posts oreder by id desc' - отсортировать вывод из БД по id
  # в порядке убывания от большего к меньшему
  @results = @db.execute 'select * from Posts order by id desc'
  erb :index
end

# обработчик get-запроса /new
# (браузер получает страницу с сервера)
get '/new' do
  erb :new
end

# обработчик post-запроса /new
# (браузер отправляет страницу на серверб мы их принимаем)
post '/new' do
  # получаем переменную из post-запроса браузера со страницы new.erb <textarea name="content" class="form-control" placeholder="Type post text here" id="floatingTextarea2" style="height: 150px"></textarea>
  @user_post = params[:content]

  if @user_post.length <= 0
    @error = 'Type post text'
    return erb :new # возврат представления new.erb
  end
  # сохранение данных в БД со страницы /new
  @db.execute 'insert into Posts (created, content) values (datetime(), ?)', [@user_post]

  # перенаправление на главную страницу
  redirect to '/'
end

# вывод информации о посте; post_id - номер поста в БД, post_id "береться" из страницы index.erb
# получаем параметр из URL <a href="/details/<%= post['id'] %>">Comments<a>
get '/details/:post_id' do
  # получаем переменную из URL <a href="/details/<%= post['id'] %>">Comments<a>
  post_id = params[:post_id]

  # получаем список постов
  # (у нас будет только один пост)
  results = @db.execute 'select * from Posts where id=?', [post_id]
  # выбираем этот один пост в переменную #row
  @row = results[0]
  # возвращаем представление details.erb
  erb :details
end

# обработчик post-запроса /details/...
# # (браузер отправляет страницу на сервер, мы их принимаем)
post '/details/:post_id' do
# получаем переменную из URL <a href="/details/<%= post['id'] %>">Comments<a>
post_id = params[:post_id]

# получаем переменную из post-запроса браузера со страницы details.erb <textarea name="content" class="form-control" placeholder="Type post text here" id="floatingTextarea2" style="height: 150px"></textarea>
@user_post = params[:content]
erb "You typed comment #{@user_post} for post #{post_id}"
end

not_found do
  erb :not_found
end
