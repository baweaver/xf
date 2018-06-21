# frozen_string_literal: true

require 'xf/scope'
require 'xf/trace'
require 'xf/trace_value'
require 'xf/trace_key_value'

module Xf
  module PublicApi
    # Combines a list of functions, or items that respond to `to_proc`, into
    # a function chain that can be called against a target.
    #
    # @note
    #   This _could_ be done with reduce, but we're trying to keep performance
    #   as close to vanilla as possible.
    #
    # @param *fns [#to_proc] List of objects coercible into Procs
    #
    # @return [Proc[Any] -> Any]
    def pipe(*fns)
      Proc.new { |target|
        new_value = target
        fns.each { |fn| new_value = fn.to_proc.call(new_value) }
        new_value
      }
    end

    alias_method :p, :pipe

    # The more traditional functional Compose, where things go in the opposite
    # order. Pipe is probably more intuitive to Rubyists, which is why this
    # is an implementation of pipe.
    #
    # @see #pipe
    def compose(*fns)
      pipe(*fns.reverse)
    end

    alias_method :c, :compose


    # Creates a Scope.
    #
    # @see Xf::Scope
    #
    # @note
    #   See the README for more instructions on usage. Will likely propogate
    #   more examples here and into the specs later.
    #
    # @param *paths [Array[Any]] Hash#dig accessible segments
    #
    # @return [Xf::Scope]
    def scope(*paths)
      Scope.new(paths.flatten)
    end

    alias_method :s, :scope

    # Creates a Trace.
    #
    # @see Xf::Trace
    #
    # @param trace_path [Any]
    #   Any hash key to dive searching for.
    #
    # @return [Xf::Trace]
    def trace(trace_path)
      Trace.new(trace_path)
    end

    alias_method :t, :trace

    # Creates a TraceValue, which matches against a value rather than a key.
    #
    # @see Xf::TraceValue
    #
    # @param trace_path [Any]
    #   Any hash value to dive searching for
    #
    # @return [Xf::TraceValue]
    def trace_value(trace_path)
      TraceValue.new(trace_path)
    end

    alias_method :tv, :trace_value

    # Creates a TraceKeyValue, which matches against a value rather than a key.
    #
    # @see Xf::TraceKeyValue
    #
    # @param trace_path [Any]
    #   Any hash value to dive searching for
    #
    # @return [Xf::TraceValue]
    def trace_key_value(trace_key, trace_value)
      TraceKeyValue.new(trace_key, trace_value)
    end

    alias_method :tkv, :trace_key_value

    # Clamps a value to be within a range. Works with numbers, dates, and other
    # items. More of a utility function.
    #
    # @param start_range [Any]
    #   Start of a range
    #
    # @param end_range [Any]
    #   End of a range
    #
    # @return [Proc[Any] -> Any]
    #   Proc that returns a value that's been clamped to the given range
    def clamp(start_range, end_range)
      Proc.new { |target|
        next start_range if target < start_range
        next end_range   if target > end_range

        target
      }
    end

    # Counts by a function. This is entirely because I hackney this everywhere in
    # pry anyways, so I want a function to do it for me already.
    #
    # @param targets [Array[Any]] Targets to count
    # @param &fn     [Proc]       Function to define count key
    #
    # @return [Hash[Any, Integer]] Counts
    def count_by(targets, &fn)
      fn ||= -> v { v }

      targets.each_with_object(Hash.new(0)) { |target, counts|
        counts[fn[target]] += 1
      }
    end

    def slice(*keys)
      Proc.new { |hash| hash.slice(*keys) }
    end

    # Solely meant as a tap addendum
    #
    # @return [Proc[Any] -> nil]
    #   nil from puts result
    def log
      Proc.new { |target| puts target }
    end
  end
end
