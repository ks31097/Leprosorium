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
  @results = @db.execute 'select * from Posts oreder by id desc'
  erb :index
end

# обработчик get-запроса /new
# (браузер получает страницу с сервера)
get '/new' do
  erb :new
end

# обработчик post-запроса /new
# (браузер отправляет страницу на сервер)
post '/new' do
  # получаем переменную из post-запроса браузера со страницы new.erb <textarea name="content" class="form-control" placeholder="Type post text here" id="floatingTextarea2" style="height: 150px"></textarea>
  @user_post = params[:content]

  if @user_post.length <= 0
    @error = 'Type post text'
    return erb :new # возврат представления new.erb
  end
  # сохранение данных в БД со страницы /new
  @db.execute 'insert into Posts (created, content) values (datetime(), ?)', [@user_post]

  erb "You typed: #{@user_post}"
end
