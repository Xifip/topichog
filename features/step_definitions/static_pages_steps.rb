#cutom steps for querying html


Then /I should see the image "(.+)"$/ do |image|
    page.should have_xpath("//img[@src=\"/public/images/#{image}\"]")
end
