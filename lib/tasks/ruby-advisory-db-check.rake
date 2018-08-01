require 'open-uri'
require 'zip'
require 'yaml'
require 'bundler'
require 'rubygems'

DATABASE_FILE = 'https://github.com/rubysec/ruby-advisory-db/archive/master.zip'
TEMP_DIR      = 'tmp/check_advisory_db'
TEMP_FILE     = "#{TEMP_DIR}/master.zip"

namespace :advisory_db do
  desc 'Check the Gems for advisories.'
  task :check => :environment do
    global_result = true

    # Download the database
    FileUtils::mkdir_p TEMP_DIR
    File.open(TEMP_FILE, 'wb') do |file|
      file.write open(DATABASE_FILE).read
    end

    # Extract all the advisory YAML files for each Gem
    Zip::File.open("#{TEMP_DIR}/master.zip") do |zipfile|
      zipfile.each do |file|
        if /^ruby-advisory-db-master\/gems\/.*\.yml$/ =~ file.name
          file_path = "#{TEMP_DIR}/#{file.name.gsub(/ruby-advisory-db-master\/gems\//, '')}"
          FileUtils.mkdir_p File.dirname(file_path)
          zipfile.extract(file, file_path)
        end
      end
    end
    FileUtils.remove(TEMP_FILE)

    # Check all Gem versions for advisories and output them
    Bundler.load.specs.each do |spec|
      spec_dir = "#{TEMP_DIR}/#{spec.name}"

      if File.directory?(spec_dir)
        Dir["#{spec_dir}/*.yml"].each do |advisory_file|
          result        = false
          good_versions = []
          advisory      =  YAML.load_file(advisory_file)
          advisory['unaffected_versions'].each {|i| good_versions << i} if advisory['unaffected_versions']
          advisory['patched_versions'].each    {|i| good_versions << i} if advisory['patched_versions']

          good_versions.each do |version|
            version = version.split(',')
            version.each do |v|
              result |= Gem::Dependency.new('', v).match?('', spec.version) rescue result |= false
            end
          end

          unless result
            global_result = false

            puts '------------------------------------------------------------------------'
            puts "#{spec.name} - #{advisory['title']}"
            puts "See: #{advisory['url']}"
            puts ''
            puts advisory['description']
            puts '------------------------------------------------------------------------'
            puts ''
          end
        end
      end
    end

    # clean the temp files and fail if there was an advisory
    FileUtils.rm_rf(TEMP_DIR)
    fail('One or more Gems have an advisory!') unless global_result
  end
end
