### This script loads all the files specified by the "path" keyword in res.yaml by cloning
### the whole project from url then moving and renaming them on the site
require 'yaml'
require_relative 'utils'

# Main script
def main
    res = YAML.load_file('res.yaml')

    res.each do |key, content|
        puts "Loading documentation from #{content["url"]}"
        puts "..."

        # gets exact repo name from url
        repoName = (content["url"].split("/")[-1]).split(".")[0] 

        # Deletes current site folder if it existed
        system("rm -rf ../../_experimentations/#{repoName}")
        system("mkdir ../../_experimentations/#{repoName}")

        # Git clone the whole project
        system("rm -rf #{repoName}")
        system("git clone #{content["url"]} #{repoName}")
    
        # Runs through each files to be included and moves/renames them to a new folder
        for path in content["paths"] do
            fileName = path.split("/")[-1]
            dateShort = `cd #{repoName} ; git log -1 --format=%cs #{path}`.chomp() # Gets the date of the last commit on this file
            dateIso = `cd #{repoName} ; git log -1 --format=%cI #{path}`.chomp() # Gets the date of the last commit on this file Iso format
            file_prepend("#{repoName}/#{path}", dateIso, "#{repoName}")
            system("mv #{repoName}/#{path} ../_experimentations/#{repoName}/#{dateShort}-#{fileName}")
            create_index("../__experimentations/#{repoName}", "#{repoName}", "#{content["project-title"]}")
        end
    
        # Remove the cloned repo
        system("rm -rf #{repoName}")
    
        puts "#{repoName}\'s documentation loaded successfully!"
    end 
end

main