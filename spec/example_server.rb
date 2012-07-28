# usage: ruby -I lib spec/example_server.rb

require 'remote_includes'
require 'sinatra'

def render_remoted_url_for(type)
  <<-EOF
<html>
  <body>
    #{type}: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}
    #{RemoteIncludes::Backend.render_remote("/partial/header", :type => type)}
  </body>
</html>
  EOF
end

before do
  RemoteIncludes::Backend.base_uri = request.url.to_s
  # to make sure varnish doesn't cache this
  headers 'Cache-Control' => "max-age=0"
end

get '/esi' do
  render_remoted_url_for('esi')
end

get '/ssi' do
  render_remoted_url_for('ssi')
end

get '/synchronous' do
  render_remoted_url_for("synchronous")
end

get '/javascript' do
  render_remoted_url_for("javascript")
end

get '/partial/header' do
  %{<h1>This is a cool website #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}</h1>}
end
