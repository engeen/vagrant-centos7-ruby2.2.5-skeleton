
include_recipe "rvm::system_install"
rvm_default_ruby "2.2.5"

rvm_gem "bundler" do 
  ruby_string "ruby-2.2.5"
  action      :install
end

rvm_gem "rake" do
  ruby_string "ruby-2.2.5"
  action      :install
end

rvm_gem "sinatra" do
  ruby_string "ruby-2.2.5"
  action      :install
end

# execute 'add deployer to rvm group' do
# 	command "usermod -a -G rvm deployer"
# end