web: bundle exec puma -s -C config/puma.rb -p $PORT                     # Command to start web server
worker: bundle exec sidekiq -C ./config/sidekiq.yml -r ./application.rb # Command to start sidekiq
