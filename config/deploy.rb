# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'qna'
set :repo_url, 'git@github.com:georgiybykov/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/qna'
set :deploy_user, 'deploy'

set :pty, false

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key', '.env.production'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'
