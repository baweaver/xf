# frozen_string_literal: true

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
  end
end
