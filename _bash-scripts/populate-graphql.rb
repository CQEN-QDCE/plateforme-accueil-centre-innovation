# This script loads all the files specified by the "path" keyword in res.yaml by cloning
# the whole project from url then moving and renaming them on the site
# option: --trace to get full exception error messages
require 'yaml'
require_relative 'utils'
require 'colorize'
require 'json'
require 'cgi'

# Main script
def main
    secret = check_secret()
    
    trace = ARGV.include? "--trace"

    res = YAML.load_file('res.yml')
    nb_docs = 0
    nb_success = 0

    puts "==========================================="
    
    # Deletes current site folder if it existed
    system("rm -rf ../_experimentations/*")

    res.each do |key, content|
        begin
            exception = false
            nb_docs += content["paths"].length()
            content["url"] = CGI.unescape(content["url"]) # Decodes url symbols into literal characters
            puts "Loading documentation from #{key}".yellow
            
            # gets exact repo name from url
            repoName = (content["url"].split("/")[-1]).gsub(".git", "")
            # gets exact repo path (ex: cqen-qdce/plateforme-accueil-centre-innovation)
            repoPath = content["url"].split("github.com/")[1].gsub(".git", "")
            # gets repo owner (ex: CQEN-QDCE)
            owner = repoPath.split('/')[0]

            system("mkdir ../_experimentations/#{repoName}")

            # Get repo description and last push to default branch
            command = 'curl -s -H "Authorization: Bearer ' + secret + '" \
                    -H  "Content-Type:application/json" \
                    -d \'{ 
                         "query": "{ repository(owner: \"' + owner + '\", name: \"' + repoName + '\") '+
                         ' { description, pushedAt } }"}\' https://api.github.com/graphql '
            json = JSON.parse(`#{command}`)
            if (json["message"])
                if(json["message"] == "Bad credentials")
                    raise "API call failed due to bad credentials, please check validity of your secret \n" +
                    "api message: #{json["message"]}"
                end
                raise "API call failed, \napi message: #{json["message"]}"
            end
            description = json["data"]["repository"]["description"]
            repoDate = json["data"]["repository"]["pushedAt"]

        rescue => e
            puts(">>> A fatal error occured while trying to process this project".light_red)
                if trace
                    puts(">>> Full exception: #{e.full_message}".light_black)
                else
                    puts(">>> ERROR: #{e.message}".light_red)
                    puts(">>> Call this script with the --trace option if you want to see the full error".light_black)
                end
                exception = true
                error = true
        else # if no exceptions were raised
            # Runs through each files to be included and moves/renames them to a new folder
            for path in content["paths"] do
                begin
                    path = CGI.unescape(path) # Decodes url symbols into utf characters
                    puts("-- #{path}".yellow)
                    url = path
                    fileName = path.split("/")[-1]
                    filePath1 = path.split("blob/")[-1]
                    branch = filePath1.split("/")[0]
                    filePath = filePath1.gsub(branch + "/", "")
                    if trace
                        puts("##############################")
                        puts(">>> url: #{url}")
                        puts(">>> fileName: #{fileName}")
                        puts(">>> filePath1: #{filePath1}")
                        puts(">>> branch: #{branch}")
                        puts(">>> filePath: #{filePath}")
                        puts("##############################")
                    end
                    # getting the date with the graphql github api
                    command = 'curl -s -H "Authorization: Bearer ' + secret + '" \
                    -H  "Content-Type:application/json" \
                    -d \'{ 
                         "query": "{ repository(owner: \"' + owner + '\", name: \"' + repoName + '\") '+
                         '{ ref(qualifiedName: \"refs/heads/' + branch + '\") ' +
                         '{ target { ... on Commit { history(first: 1, path: \"' + filePath + '\") ' + 
                         '{ edges { node { committedDate } } } } } } } }"}\' https://api.github.com/graphql '
                    json = JSON.parse(`#{command}`)
                    if (!$?.success?)
                        raise "Impossible to get date from github api, check if project's url for " +
                        "#{key} is valid. If it is, you may be getting rate limited by the github api.\n"
                    else
                        dateIso = json["data"]["repository"]["ref"]["target"]["history"]["edges"][0]["node"]["committedDate"] # I am so sorry but it's graphql's fault
                        dateShort = dateIso[0..9] # Gets the date of the last commit on this file YYYY-MM-DD format
                    end

                    raw = path.gsub("github.com", "raw.githubusercontent.com").gsub("/blob/", "/") # Gets raw file from normal url
                    puts("wget --header=\"Authorization: token #{secret}\" #{raw}")

                    system("wget --header=\"Authorization: token #{secret}\" #{raw}")
                    
                    if (!$?.success?)
                        raise "Impossible to wget file from #{path}, check if path provided is valid.\n"
                    end
                    process_file(fileName, dateIso, repoName, path, path.chomp(filePath))
                    system("mv #{fileName} ../_experimentations/#{repoName}/#{dateShort}-#{fileName}")
                    create_index("../_experimentations/#{repoName}", "#{repoName}", content["project-title"], 
                        content["url"], description, repoDate)
                    nb_success += 1
                rescue => e
                    puts(">>> An error occured while processing file".light_red)
                    system("rm #{fileName}")
                    if trace
                        puts(">>> Full exception: #{e.full_message}".light_black)
                    else
                        puts(">>> ERROR: #{e.message}".light_red)
                        puts(">>> Call this script with the --trace option if you want to see the full error".light_black)
                    end
                    exception = true
                    error = true
                end
            end
            if !exception
                puts "#{repoName}\'s documentation loaded successfully!".green
            else
                puts "Some or all documents have not been successfully loaded, check console output".magenta
            end
        end
        puts "==========================================="
    end 
    if nb_docs != nb_success
        puts "#{nb_success}/#{nb_docs} files passed! Check console output to fix errors.".red
        exit 1
    else
        puts "#{nb_success}/#{nb_docs} files passed! The documentation has been successfully loaded.".green
        exit 0
    end
end

main