root = "#{Dir.getwd}"
activate_control_app "tcp://127.0.0.1:9293"
bind "unix:///tmp/puma.pumatra.sock"
rackup "#{root}/config.ru"
