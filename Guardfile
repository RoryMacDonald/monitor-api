def match_one_of(items)
  "(?:#{items.join("|")})"
end

def run_spec_on_change(directories, filetypes)
  directory_regex = match_one_of(directories)
  file_type_regex = match_one_of(filetypes)
  watch(%r{^#{directory_regex}/(.+)\.#{file_type_regex}$})  { "spec" }
end

guard :rspec, cmd: "bundle exec rspec" do
  run_spec_on_change(['lib', 'spec'], ['rb','json'])
end
