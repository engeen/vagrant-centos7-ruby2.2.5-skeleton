# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'fileutils'

CONFIG = File.join(File.dirname(__FILE__), "vagrant.local.rb")

$dev_ip = "192.168.12.100"
$dev_memory = 4096


$test_hosts = {
 # test_app:      { ip: "192.168.12.101", mem: 1024, hostname: "app1", ports: { 80 => 80, 3000 => 3000, 9292 => 9292} }
}



require CONFIG if File.readable?(CONFIG)

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/centos-7.2"
  config.ssh.forward_agent = true
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  #config.vm.hostname = "aeron.my"
  #config.hostsupdater.aliases = ["alias.testing.de", "alias2.somedomain.com"]



  $test_hosts.keys.each do |host|
    config.vm.define host.to_s, autostart: false do |srv|
      srv.vm.hostname = $test_hosts[host][:hostname]
      srv.vm.provider "virtualbox" do |vb|
        vb.memory =  $test_hosts[host][:mem]
      end
      srv.vm.network :private_network, ip: $test_hosts[host][:ip]



      srv.vm.provision :shell, inline: "sudo mkdir -p -m 700 /root/.ssh"
      srv.vm.provision "file", source: "config/id_rsa_test.pub", destination: "~/id_rsa_test.pub"
      srv.vm.provision :shell, inline: 'sudo cat /home/vagrant/id_rsa_test.pub > /root/.ssh/authorized_keys'
      srv.vm.provision :shell, inline: 'sudo chmod 600 /root/.ssh/authorized_keys'


      if $test_hosts[host].has_key?(:ports)
        $test_hosts[host][:ports].keys.each do |from|
          srv.vm.network "forwarded_port", guest: from, host: $test_hosts[host][:ports][from], auto_correct: true
        end
      end


    end

  end





  config.vm.define "dev", autostart: false do |dev|

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # config.vm.synced_folder "../aeron_code", "/home/vagrant/aeron_code"
    if ENV['USE_NFS'] == 'true'
      dev.vm.synced_folder  ".", "/home/vagrant/app", type: 'nfs', mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
    else
      dev.vm.synced_folder  ".", "/home/vagrant/app", type: "virtualbox"
    end

    dev.vm.provider "virtualbox" do |vb|
      vb.memory = $dev_memory
    end
    dev.vm.network :private_network, ip: $dev_ip

    # Forward the Rails server default port to the host
    #config.vm.network :forwarded_port, guest: 3000, host: 3000
    #config.vm.network "private_network", ip: "192.168.33.10"
    # dev.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
    # dev.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true

    dev.librarian_chef.cheffile_dir = "chef"
    dev.vm.provision :shell, inline: "sudo yum -y install kernel-devel.x86_64"
    dev.vm.provision :shell, inline: "sudo yum -y install git"


    # Use Chef Solo to provision our virtual machine
    dev.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["chef/cookbooks", "chef/site-cookbooks"]
      chef.environments_path = "chef/environments"
      chef.roles_path = "chef/roles"
      chef.nodes_path = "chef/nodes"
      
      chef.add_role("developer")

      chef.node_name = "dev"
      chef.environment = "development"
    end

    # dev.vm.provision :shell, inline: "sudo service elasticsearch start"
    # dev.vm.provision :shell, inline: "cd /home/vagrant/insurance && bundle install"
    # dev.vm.provision :shell, inline: "cd /home/vagrant/insurance && cp config/database.yml.mysql config/database.yml"
    # #dev.vm.provision :shell, inline: "cd /home/vagrant/insurance && rake db:create"
    # dev.vm.provision :shell, inline: "cd /home/vagrant/insurance && rake db:migrate"
    # dev.vm.provision :shell, inline: "cd /home/vagrant/insurance && rake db:seed"

    dev.vm.provision :shell, inline: "git config --global core.autocrlf input"
    #dev.vm.provision "shell", path: 'provisions/gitcrlf.sh', privileged: false
  end





  config.vm.post_up_message = "\n\nProvisioning is done.
  Current OS: Centos/Linux 7.2 x64\n\n
  "

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end



end
