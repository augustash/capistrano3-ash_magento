# Snapshot settings
set :snapshot_path, -> { "#{fetch(:deploy_to)}/snapshots" }

# n98-magerun settings
set :magerun_filename, "n98-magerun.phar"
set :magerun_download_url, "http://files.magerun.net/n98-magerun-latest.phar"
set :magerun_path, -> { "#{fetch(:deploy_to)}/#{magerun_filename}" }
set :magerun, -> { "#{magerun_path}" }
