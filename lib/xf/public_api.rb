# frozen_string_literal: true

require 'xf/scope'

module Xf
  module PublicApi
    # Composes a list of functions, or items that respond to `to_proc`, into
    # a function chain that can be called against a target.
    #
    # @param *fns [#to_proc] List of objects coercible into Procs
    #
    # @return [Proc[Any] -> Any]
    def compose(*fns)
      chain = fns.map(&:to_proc)

      Proc.new { |target|
        chain.reduce(target) { |t, fn| fn.call(t) }
      }
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
    # @param *path [Array[Any]] Hash#dig accessible segments
    #
    # @return [Xf::Scope]
    def scope(*path)
      Scope.new(path)
    end

    alias_method :s, :scope
  end
end
