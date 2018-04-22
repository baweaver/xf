# frozen_string_literal: true

begin
  require 'benchmark/ips'
  require "rspec/core/rake_task"
  require "rubocop/rake_task"

  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new

  # Gemsmith CI shenanigans
  if RUBY_VERSION >= '2.5.0'
    require "gemsmith/rake/setup"
    require "bundler/audit/task"
    require "git/cop/rake/setup"
    require "reek/rake/task"

    Reek::Rake::Task.new
    Bundler::Audit::Task.new
  end
rescue LoadError => error
  puts error.message
end

# Gemsmith CI shenanigans
if RUBY_VERSION >= '2.5.0'
  desc "Run code quality checks"
  task code_quality: %i[bundle:audit git_cop reek rubocop]
end

task default: %i[spec]

# Run a benchmark given a title and a set of benchmarks. Admittedly this
# is done because the Benchmark.ips code can get a tinge repetitive and this
# is easier to write out.
#
# @param title [String] Title of the benchmark
# @param **benchmarks [Hash[Symbol, Proc]] Name to Proc to run to benchmark it
#
# @note Notice I'm using `'String': -> {}` instead of hashrockets? Kwargs doesn't
#       take string / hashrocket arguments, probably to prevent abuse of the
#       "anything can be a key" bit of Ruby.
#
# @return [Unit] StdOut
def run_benchmark(title, **benchmarks)
  puts '', title, '=' * title.size, ''

  # Validation
  benchmarks.each do |benchmark_name, benchmark_fn|
    puts "#{benchmark_name} result: #{benchmark_fn.call()}"
  end

  puts

  Benchmark.ips do |bm|
    benchmarks.each do |benchmark_name, benchmark_fn|
      bm.report(benchmark_name, &benchmark_fn)
    end

    bm.compare!
  end
end

def xrun_benchmark(title, **benchmarks) end

task :perf do
  puts "Running on Xf v#{Xf::Identity.version} at rev #{`git rev-parse HEAD`} - Ruby #{`ruby -v`}"

  number_strings_array = %w(1 2 3 4 5 6 7 8 9 10)
  run_benchmark('Composition',
    'Vanilla':    -> { number_strings_array.map { |s| s.to_i.succ } },
    'Xf#compose': -> { number_strings_array.map(&Xf.c(:to_i, :succ)) }
  )

  deep_hash = {a: {b: {c: {d: {e: {f: 1}}}}}}

  run_benchmark('Scope Get',
    'Vanilla':      -> { deep_hash.dig(:a, :b, :c, :d, :e, :f) },
    'Xf#get':       -> { Xf.scope(:a, :b, :c, :d, :e, :f).get.call(deep_hash) },
    'Xf#get_value': -> { Xf.scope(:a, :b, :c, :d, :e, :f).get_value(deep_hash) }
  )

  run_benchmark('Scope Set - No mutation',
    'Vanilla':      -> {
      h = Marshal.load(Marshal.dump(deep_hash))
      h[:a][:b][:c][:d][:e][:f] = 5
      h
    },

    'Xf#set':       -> { Xf.scope(:a, :b, :c, :d, :e, :f).set(5).call(deep_hash) },
    'Xf#set_value': -> { Xf.scope(:a, :b, :c, :d, :e, :f).set_value(deep_hash, 5) }
  )

  new_deep_hash = Marshal.load(Marshal.dump(deep_hash))
  run_benchmark('Scope Set - Mutation',
    'Vanilla':       -> { new_deep_hash[:a][:b][:c][:d][:e][:f] = 5; new_deep_hash },
    'Xf#set!':       -> { Xf.scope(:a, :b, :c, :d, :e, :f).set!(5).call(new_deep_hash) },
    'Xf#set_value!': -> { Xf.scope(:a, :b, :c, :d, :e, :f).set_value!(new_deep_hash, 5) }
  )
end

task :symbolized_perf do
  symbol = :even?
  target = 2

  run_benchmark('Scope Set - Mutation',
    'send':    -> { target.public_send(symbol) },
    'to_proc': -> { symbol.to_proc.call(target) }
  )
end

