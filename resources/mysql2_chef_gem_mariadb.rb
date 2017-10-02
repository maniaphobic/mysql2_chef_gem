property :mysql2_chef_gem_name, String, name_property: true, required: true
property :gem_name, String, default: 'mysql2'
property :gem_version, String, default: '0.4.9'
property :package_version, String

provides :mysql2_chef_gem_mariadb

gem_binary_path = RbConfig::CONFIG['bindir'] + '/gem'

action :install do
  recipe_eval do
    run_context.include_recipe 'build-essential::default'
  end

  # As a recipe: must rely on global node attributes
  recipe_eval do
    run_context.include_recipe 'mariadb::client'
  end

  gem_name = new_resource.gem_name
  gem_package "install_gem_package_#{gem_name}" do
    gem_binary gem_binary_path
    package_name gem_name
    version new_resource.gem_version
    action :install
  end
end

action :remove do
  gem_name = new_resource.gem_name
  gem_package "remove_gem_package_#{gem_name}" do
    gem_binary gem_binary_path
    package_name gem_name
    action :remove
  end
end
