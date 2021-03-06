#
# Recipe:: users-and-roles-for-oracle-unix
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute

# User and roles creation for Oracle installation

# Create groups - begin
# https://docs.chef.io/resource_group.html

# Common install group for all oracle related users
group 'oinstall' do
  action :create
  gid '511'
end

# ASM administrator - for grid user
group 'asmadm' do
  action :create
  gid '512'
end

# ASM user  - for DB create user (like oracle) and for grid user
group 'asmdba' do
  action :create
  gid '513'
end

# For OEM software owner
group 'oemadm' do
  action :create
  gid '514'
end
# Create groups - end

# Create users - begin
# https://docs.chef.io/resource_user.html

# Create users
# NOTE: gid be without quotes - because upon re-run it is erroring out with the following error:
#                                     User: Couldn't lookup integer GID for group name 901

user 'oracle' do
  comment 'Oracle DB and Client software owner'
  uid '91'
  #gid 511
  group 'oinstall'
  home '/home/oracle'
  shell '/bin/bash'
  password 'oracle'
end

user 'grid' do
  comment 'Oracle grid software owner'
  uid '92'
  #gid 511
  group 'oinstall'
  home '/home/oracle'
  shell '/bin/bash'
  password 'oracle'
end

user 'oem' do
  comment 'Oracle OEM software owner'
  uid '93'
  #gid 511
  group 'oinstall'
  home '/home/oracle'
  shell '/bin/bash'
  password 'oracle'
end

# Create users - end

# Add users to additional groups
group 'asmdba' do
  members 'oracle'
  append true
end

group 'asmdba' do
  members 'grid'
  append true
end

group 'asmadm' do
  members 'grid'
  append true
end

group 'oemadm' do
  members 'oem'
  append true
end
# Add users to additional groups - end

# Create directory - begin
# https://docs.chef.io/resource_directory.html

%w[ /home /u01 /u01/app ].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

%w[ /u01/app/oraInventory ].each do |path|
  directory path do
    owner 'oracle'
    group 'oinstall'
    mode '0775'
    action :create
  end
end

%w[ /home/oracle /u01/app/oracle ].each do |path|
  directory path do
    owner 'oracle'
    group 'oinstall'
    mode '0755'
    action :create
  end
end

%w[ /home/grid /u01/app/grid ].each do |path|
  directory path do
    owner 'grid'
    group 'oinstall'
    mode '0755'
    action :create
  end
end

%w[ /home/oem /u01/app/oem ].each do |path|
  directory path do
    owner 'oem'
    group 'oinstall'
    mode '0755'
    action :create
  end
end

%w[ /usr/local/tns ].each do |path|
  directory path do
    owner 'oracle'
    group 'oinstall'
    mode '0775'
    action :create
  end
end
# Create directory - end
