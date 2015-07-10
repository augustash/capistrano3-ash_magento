load File.expand_path("../tasks/magento.rake", __FILE__)
load File.expand_path("../tasks/snapshot.rake", __FILE__)

namespace :load do
  task :defaults do
    load 'capistrano/ash_magento/defaults.rb'
  end
end
