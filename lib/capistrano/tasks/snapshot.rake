namespace :snapshot do
  namespace :check do
    desc 'Check that necessary directories exist'
    task :directories do
      on roles(:web) do
        execute :mkdir, '-pv', fetch(:snapshot_path)
      end
    end

    desc <<-DESC
      Check if n98-magerun has been installed on the server. If not, try installing it. \
      See https://github.com/netz98/n98-magerun
    DESC
    task :magerun do
      on roles(:web) do
        if test("[ -f #{fetch(:magerun_path)} ]")
          # n98-magerun exists!
          logger.info "n98-magerun is installed!"
        else
          logger.info "n98-magerun IS NOT INSTALLED! Trying to install n98-magerun via cURL within #{deploy_to}"

          # try to install the n98-magerun in the :deploy_to path
          within deploy_to do
            execute :curl, '-sS', fetch(:magerun_download_url), '-o', fetch(:magerun_filename)
          end
        end
      end
    end
  end

  desc <<-DESC
    Creates snapshot of database and saves as compressed file using the n98-magerun tool. \
    See https://github.com/netz98/n98-magerun
  DESC
  task :create do
    on roles(:web) do
      within release_path do

        git_sha         = "#{capture("cd #{repo_path} && git rev-parse HEAD")}"
        datetime        = Time.now.strftime("%Y%m%d%H%M")
        filename        = "#{fetch(:snapshot_path)}/#{git_sha}_#{datetime}.sql.gz"

        execute "#{fetch(:magerun)}", "db:dump", "--root-dir=\"#{release_path}\"", '--compression="gzip"', '--strip="@stripped"', "#{filename}"
      end
    end
  end
end