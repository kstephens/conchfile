# -*- ruby -*-

guard 'rspec', cmd: 'bundle exec rspec' do
  watch(%r{^lib/conchfile/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^(spec/(.*)spec)})             { |m| m[1] }
  watch(%r{^spec/(.*)spec_helper.rb$})    { "spec" }
end

