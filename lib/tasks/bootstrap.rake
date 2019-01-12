# frozen_string_literal: true

require "fileutils"

task :bootstrap do
  sh %{ bundle install }
  sh %{ rake db:drop db:create db:migrate }
  sh %{ rake db:seed }
end
