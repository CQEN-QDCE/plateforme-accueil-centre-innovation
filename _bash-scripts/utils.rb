### This script contains utility functions used by populate-raw.rb

# Looks for the links in the document and checks if they are relative paths instead of direct url
def broken_links(file, repoUrl)
  scan = file.scan(/\!?\[.*?\]\([^#].*?\)/) # checks for [text](link) format (and not [text](#link))
  for elem in scan do
    if (!elem.include?("http"))
      link = elem[/(?<=\().*(?=\))/] # get the link in between ()
      if (elem[0] == "!") # if the markdown link is actually a multimedia resource
        newlink = repoUrl + link + "?raw=true"
      else
        newlink = repoUrl + link
      end
       newlink = elem.gsub(/(?<=\().*(?=\))/, newlink) # puts the new link in the [text](link) format
      file = file.gsub(elem, newlink) # replaces the original link format
      puts "broken link found, automatically replaced \"#{link}\" with \"#{newlink}\"\n".cyan
    end
  end
  return file
end

# Prepends a jekyll header to a file by replacing the file, iterating through each line and checking for broken links
# (loops through each line to not load all of the lines into memory at the same time)
def process_file(fileName, date, repoName, url, repoUrl)
    new_contents = ""
    str = 
    "---\n" +
    "date: #{date}\n" +
    "permalink: experimentations/#{repoName}/#{fileName.split('.')[0]}.html\n" +
    "layout: post\n" +
    "type: posts\n" +
    "project: #{repoName}\n" +
    "github: #{url}\n" +
    "index: false\n" +
    "---\n"
    File.open(fileName, 'r') do |fd|
      contents = broken_links(fd.read, repoUrl)
      new_contents = str << contents
    end
    # Overwrite file but now with prepended string on it
    File.open(fileName, 'w') do |fd| 
      fd.write(new_contents)
    end
end

# Creates an index for the project, which will list and reference the different docs of the project
def create_index(path, repoName, projectTitle, url, description, repoDate)
    str = 
    "---\n" +
    "title: #{projectTitle}\n" +
    "layout: index-lab\n" +
    "project: #{repoName}\n" +
    "permalink: experimentations/#{repoName.gsub(' ', '-')}/index.html\n" +
    "index: true\n" +
    "github: #{url}\n" +
    "date: #{repoDate}\n" +
    "---\n" +
    description
    
    File.open(path + "/index.md", 'w') {|f| f.write(str) }
end

# used for debugging to make the console wait for input
def waitForInput
  puts("Waiting for input:")
  gets.chomp.upcase
end

# Checks if secret exist and if not prompts the user to enter one
# Returns the fetched secret
def check_secret
  index = ARGV.find_index("--secret")
  puts "searching for API token #{ENV["API_TOKEN"]}"

  if (index && ARGV[index+1]) # --secret 12345
    puts "Using secret from provided argument".cyan
    secret = ARGV[index+1].delete("\n")

  elsif (index && !ARGV[index+1]) # --secret
    puts "Please respect the argument syntax of --secret <your_secret>".red
    abort
  
  elsif (ENV["API_TOKEN"]) # fetches env variable
    puts "Using secret from environment variable".cyan
    secret = ENV["API_TOKEN"]
    puts secret

  # else # no arguments
  #   puts "Fetching API key from local files...".yellow
  #   secret = strVar = File.open('secret') {|f| f.readline}
  #   secret = secret.delete("\n")
  end

  return secret
end