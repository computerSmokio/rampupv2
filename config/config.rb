# See http://docs.chef.io/workstation/config_rb/ for more information on knife configuration options

current_dir = File.dirname(__FILE__)
cookbooks_dir=ENV["COOKBOOKS_DIR"]
log_level                :info
log_location             STDOUT
node_name                "chefadmin"
client_key               "#{current_dir}/chefadmin.pem"
chef_server_url          "https://chef-infra-server/organizations/rampup"
cookbook_path            ["#{cookbooks_dir}"]
