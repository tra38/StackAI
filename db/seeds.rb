# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'httparty'
# require 'faker'

# AI Speculation
speculation = Category.create(name: "AI Speculation", description: "This category deals with speculation about artifical intelligence. Philosophy SE uses logical reasoning to deduce facts about artifical intelligences, while Worldbuilding SE takes a science-fiction approach towards imaginging the possibilities inherent in AI.")

philosophy = Feed.create!(name: "Philosophy", url: "http://philosophy.stackexchange.com/feeds/tag/artificial-intelligence", post_url: "http://philosophy.stackexchange.com/questions/ask?tags=artificial-intelligence", description: "Philosophy SE uses logical reasoning to deduce facts about artifical intelligences.", category: speculation)

world_building = Feed.create!(name: "Worldbuilding", url: "http://worldbuilding.stackexchange.com/feeds/tag/artificial-intelligence", post_url: "http://worldbuilding.stackexchange.com/questions/ask?tags=artificial-intelligence", description: "Worldbuilding SE takes a science-fiction approach towards imaginging the possibilities inherent in AI.", category: speculation)

# AI Development
development = Category.create(name: "AI Development", description: "This category deals with topics about developing new AIs, with an emphasis on academic understanding. Computer Science focuses on the theoretical process of designing algorithms that can operate independently, while Computional Linguistics attempts to 'investigate' linguistic theory by using algorithms and specializes in NLP (natural language processing).")

designing_artificial_intelligence = Feed.create(name: "Computer Science", url:"http://cs.stackexchange.com/feeds/tag/artificial-intelligence", post_url: "http://cs.stackexchange.com/questions/ask?tags=artificial-intelligence", description: "Computer Science SE focuses on the theoretical process of designing algorithms that can operate independently.", category: development)

computional_linguistics = Feed.create(name: "Computional Linguistics", url: "http://linguistics.stackexchange.com/feeds/tag/computational-linguistics", post_url: "http://linguistics.stackexchange.com/questions/ask?tags=computational-linguistics", description: "Computional Linguistics attempts to 'investigate' linguistic theory by using algorithms and specializes in NLP (natural language processing). The field is hosted at Linguistics SE.", category: development)

# Machine Learning
machine_learning = Category.create(name: "Machine Learning", description: "This category deals with developing 'computer systems that automatically improve with experience'. Cross Validated focuses on understanding how to use these statistical algorithms to analyze data, while Data Science focuses on applying these algorithms to real-world situations. Cross Valdiated is the more popular machine learning website.")

# The more popular of the two sites
theoretical_machine_learning = Feed.create(name: "Cross Validated", url: "http://stats.stackexchange.com/feeds/tag/machine-learning", post_url: "http://stats.stackexchange.com/questions/ask?tags=machine-learning", description: "Cross Validated deals with understanding how to use statistical machine learning algorithms to analyze data.", category: machine_learning)

# A spinoff dedicated towards 'applied' machine learning. Currently suffering from inactivity.
applied_machine_learning = Feed.create(name: "Data Science", url: "http://datascience.stackexchange.com/feeds/tag/machine-learning", post_url: "http://datascience.stackexchange.com/questions/ask?tags=machine-learning", description: "Data Science SE focuses on applying machine learning algorithms to real-world situations.", category: machine_learning)

# # Grab Site questions
def recursive_loop(array_of_questions, page, tag, site)
  page += 1
  new_json = HTTParty.get("https://api.stackexchange.com/2.2/questions?page=#{page}&order=desc&sort=activity&tagged=#{tag}&site=#{site}")
  new_array = array_of_questions + new_json["items"]
  if new_json["has_more"]
    recursive_loop(new_array, page, tag, site)
  else
    new_array
  end
end

# This is a mock of the actual thing, used in manual testing

# def recursive_loop(array_of_questions, page, tag, site)
#   100.times do
#     entry = Hash.new
#     entry["owner"] = Hash.new
#     entry["title"] = "How do you #{Faker::Hacker.verb} the #{Faker::Hacker.adjective} #{Faker::Hacker.noun}?"
#     entry["owner"]["display_name"] = "#{Faker::App.author}"
#     entry["owner"]["link"] = "http://example.com"
#     entry["link"] = "http://example.com"
#     entry["creation_date"] = Time.at(rand * Time.now.to_i)
#     array_of_questions << entry
#   end
#   array_of_questions
# end

def save_questions(array_of_questions, feed)
  array_of_questions.each do |entry|
    title = entry["title"]
    content = nil
    author = entry["owner"]["display_name"]
    author_profile = entry["owner"]["link"]
    url = entry["link"]
    published = Time.at(entry["creation_date"]).to_datetime
    local_entry = feed.entries.where(title: title).first_or_initialize
    local_entry.update_attributes(content: content, author: author, url: url, published: published, author_profile: author_profile)
    p "Synced Entry - #{title}"
  end
end

philosophy_questions = recursive_loop([],0,"artificial-intelligence","philosophy")
save_questions(philosophy_questions, philosophy)

world_building_questions = recursive_loop([], 0, "artificial-intelligence", "worldbuilding")
save_questions(world_building_questions, world_building)

computer_science_questions = recursive_loop([],0,"artificial-intelligence","cs")
save_questions(computer_science_questions, designing_artificial_intelligence)

theory_machine_learning_questions = recursive_loop([],0,"machine-learning","stats")
save_questions(theory_machine_learning_questions, theoretical_machine_learning)

computional_linguistics_questions = recursive_loop([],0,"computational-linguistics","linguistics")
save_questions(computional_linguistics_questions, computional_linguistics)

machine_learning_questions = recursive_loop([],0,"machine-learning","datascience")
save_questions(machine_learning_questions, applied_machine_learning)

p "Total Sync!"
