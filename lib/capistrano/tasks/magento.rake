namespace :magento do
  desc 'Purge Magento cache directories'
  task :purge_cache do
    on roles(:web) do
      execute :rm, '-Rf', "#{shared_path}/media/css/"
      execute :rm, '-Rf', "#{shared_path}/media/css_secure/"
      execute :rm, '-Rf', "#{shared_path}/media/js/"
      execute :rm, '-Rf', "#{shared_path}/media/js_secure/"
    end
  end

  task :enable_errors do
    on roles(:app) do
      within release_path do
        execute :perl, '-pi', "-e 's/#ini_set/ini_set/g'", "#{release_path}/index.php"
      end
    end
  end

  task :disable_errors do
    on roles(:app) do
      within release_path do
        execute :perl, '-pi', "-e 's/ini_set/#ini_set/g'", "#{release_path}/index.php"
      end
    end
  end

  task :enable_mods do
    on roles(:app) do
      within "#{release_path}/app/etc/modules" do
        fetch(:modules, []).each do |name|
          execute :perl, '-pi', "-e 's/false/true/g'", "#{name}"
        end
      end
    end
  end

  task :disable_mods do
    on roles(:app) do
      within "#{release_path}/app/etc/modules" do
        fetch(:modules, []).each do |name|
          execute :perl, '-pi', "-e 's/true/false/g'", "#{name}"
        end
      end
    end
  end

  namespace :maintenance do
    desc "Enable Magento's maintenance mode"
    task :on do
      on roles(:app) do
        within release_path do
          execute :touch, "#{release_path}/maintenance.flag"
        end
      end
    end

    desc "Disble Magento's maintenance mode"
    task :off do
      on roles(:app) do
        within release_path do
          execute :rm, "#{release_path}/maintenance.flag"
        end
      end
    end
  end

  namespace :compiler do
    desc 'Enable Magento compiler include path'
    task :enable do
      on roles(:app) do
        within "#{release_path}/shell" do
          execute fetch(:php_bin, '/usr/bin/php'), "compiler.php -- enable"
        end
      end
    end

    desc 'Disable Magento compiler include path'
    task :disable do
      on roles(:app) do
        within "#{release_path}/shell" do
          execute fetch(:php_bin, '/usr/bin/php'), "compiler.php -- disable"
        end
      end
    end

    desc 'Run Magento compilation process'
    task :compile do
      on roles(:app) do
        within "#{release_path}/shell" do
          execute fetch(:php_bin, '/usr/bin/php'), "compiler.php -- compile"
        end
      end
    end

    desc 'Disable Magento compiler include path and remove compiled files'
    task :clear do
      on roles(:app) do
        within "#{release_path}/shell" do
          execute fetch(:php_bin), "compiler.php -- clear"
        end
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :linked_dirs, fetch(:linked_dirs, []).push("var", "media", "sitemaps")
    set :linked_files, fetch(:linked_files, []).push("app/etc/local.xml")
  end
end
