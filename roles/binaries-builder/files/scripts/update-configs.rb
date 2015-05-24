#!/usr/bin/env ruby
require 'fileutils'
require 'tmpdir'
require 'yaml'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: update-comfigs.rb [options]"
  opts.on('-c', '--config FILE', 'Config file') do |v|
  	if File.exist?(v)
  	  options[:config] = v
  	else
  	  puts opts.banner
  	  exit(2)
  	end
  end
end.parse!

config = YAML.load_file(options[:config])

output_folder = config['output_folder'] || File.join(ENV['HOME'], 'blobs')
FileUtils.mkdir_p(output_folder)

tmpdir = Dir.mktmpdir
new_config_folder = tmpdir

download_new_configs(new_config_folder)

packages_to_update = config['packages']
source_packages_folder = config['source_folder']

packages_to_update.each do |package|
  update_package_config(package)
end

config_files = %w(config.guess config.sub)


######## PRIVATE METHODS #################


def download_new_configs(path)
  config_files.each do |file_name|
  	puts "Downloading #{file_name}"
    execute_command(%(curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=#{file_name};hb=HEAD" > #{File.join(path, file_name)}))
    puts 'Done.'
  end
end

def update_package_config(package)
  puts "Updating config for #{package} package."
  package_scope = package.split('/').first
  package_name  = package.split('/').last
  archive_path = File.join(source_packages_folder, "#{package}.tar.gz")
  source_path = File.join(source_packages_folder, package_name)
  target_archive_folder = File.join(output_folder, package_scope)
  target_archive_path = File.join(target_archive_folder, package_name)
  puts "Unarchiving package #{archive_path}"
  execute_command(%(tar -xzvf #{archive_path} -L #{tmpdir}))
  puts 'Done.'

  folder_to_update = File.join(tmpdir, package_name)
  puts "Copying config files to #{folder_to_update}"
  config_files.each do |file_name|
  	execute_command("cp #{File.join(new_config_folder, file_name)} #{File.join(folder_to_update, 'config')}")
  end
  puts 'Done.'

  puts "Archiving package"
  FileUtils.mkdir_p(target_archive_folder)
  execute_command(%(tar -xzvf #{target_archive_path} #{package_name}), chdir: tmpdir)
  puts 'Done.'
end

def execute_command(command, options = {})
  Dir.chdir(options[:chdir]) if options[:chdir]
  puts "Executing command: #{command}"
  output = `#{command}`
  unless !?.success?
  	puts "Command Failed:"
  	puts output
    exit(2)
  end
end


