#!/usr/bin/env ruby
def bundle_install
	puts `cd ~/workspace`
	puts `bundle install`
end

def install_mysql
	unless `parts list`.match(/mariadb/)
		puts `parts install mariadb`
	end

	puts `parts start mariadb`
end

def install_postgres
    unless `parts list`.match(/postgresql/)
		puts `parts install postgresql`
    end

    puts `parts restart postgresql`
end

def install_mongo
	unless `parts list`.match(/mongodb/)
		puts `parts install mongodb`
	end

	puts `parts start mongodb`
end

def install_phantomjs
	unless `parts list`.match(/phantomjs/)
		puts `parts install phantomjs`
	end
end

def setup_database
	#puts `mysql -u root < setup_database.sh`
	#puts `rake db:reset`
	puts `rake db:setup`
end

def start_server
	puts `cd ~/workspace`
	puts `rails server -d`
end

def install_packages
	packages = [
		"ack",
		"tmux"
	]

	packages.each do |package|
		`parts install #{package}`
	end
end

#install_mysql
install_postgres
#install_mongo
install_phantomjs
bundle_install
#setup_database
start_server
install_packages