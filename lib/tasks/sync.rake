require 'httparty'

namespace :sync do
  task feeds: [:environment] do
    philosophy_questions = grab_questions("artificial-intelligence","philosophy")
    save_questions(philosophy_questions, Feed.where(name: "Philosophy"))

    world_building_questions = grab_questions("artificial-intelligence", "worldbuilding")
    save_questions(world_building_questions, Feed.where(name: "Worldbuilding"))

    computer_science_questions = grab_questions("artificial-intelligence","cs")
    save_questions(computer_science_questions, Feed.where(name: "Computer Science"))

    theory_machine_learning_questions = grab_questions("machine-learning","stats")
    save_questions(theory_machine_learning_questions, Feed.where(name: "Cross Validated"))

    computional_linguistics_questions = grab_questions("computational-linguistics","linguistics")
    save_questions(computional_linguistics_questions, Feed.where(name: "Computional Linguistics"))

    machine_learning_questions = grab_questions("machine-learning","datascience")
    save_questions(machine_learning_questions, Feed.where(name: "Data Science"))

  end

  def grab_questions(tag, sitename)
    HTTParty.get("https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&tagged=#{tag}&site=#{site}")["items"]
  end

  def save_questions(entries, feed)
    entries.each do |entry|
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
    p "Synced Feed - #{feed.name}"
  end

end