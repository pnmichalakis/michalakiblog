require 'bundler'
Bundler.require(:default)
require './models/user'
require './models/post'
require './helpers/authentication_helper'

set :database, adapter: 'postgresql', database: 'blog_db'
enable :sessions

get '/' do
  # if current_user
  #   erb :authenticated
  # else
  #   erb :not_authenticated
  # end

  @posts = Post.all
  erb :index
end

get '/users/new' do
  erb :'users/new'
end

post '/users' do
  user = User.new(params[:user])
  user.password = params[:password]
  user.save!
  redirect '/sessions/new'
end

get '/sessions/new' do
  erb :'sessions/new'
end


post '/sessions' do
  redirect '/' unless user = User.find_by(username: params[:username])
  if user.password == params[:password]
    session[:current_user] = user.id
    redirect '/'
  else
    redirect '/'
  end
end


delete '/sessions' do
  session[:current_user] = nil
  redirect '/'
end

get '/posts/new' do
  authenticate!
  erb :'posts/new'
end

post '/posts' do
  new_title = params['post_title']
  new_body = params['post_body']
  post = Post.create({title: new_title, body: new_body})
  redirect '/'
end

get '/posts/:id/edit' do
  authenticate!
  @post = Post.find(params[:id])
  erb :'/posts/edit'
end

patch '/posts/:id' do
  post = Post.find(params[:id])
  new_title = params['post_title']
  new_body = params['post_body']
  post.update({title: new_title, body: new_body})
  redirect '/'
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb :'posts/show'
end

delete '/posts/:id' do
  Post.delete(params[:id])
  redirect '/'
end