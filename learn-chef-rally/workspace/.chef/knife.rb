current_dir = File.dirname(__FILE__)
log_level								:info
log_location						STDOUT
node_name								"node_name"
client_key							"#{current_dir}/your_username.pem"
validation_client_name	"your_organization-validator"
validation_key					"#{current_dir}/your_organization-validator.pem"
chef_server_url					"https://your_chef_server_url/organizations/your_organization"
cookbook_path						["#{current_dir}/../cookbooks"]
