task default: %w[run]

desc "Runs tests"
task :test do
  ruby "test/run_test.rb"
end

desc "Runs compile"
task :run, [:infile, :outfile] do |task, args|
  ruby "main.rb #{args.infile} #{args.outfile}"
end