module Xf
  # Traces based on a value matching. Only overrides the `match?`
  # method to redefine a matched node.
  #
  # @see Xf::Trace
  #
  # @author baweaver
  # @since 0.1.0
  #
  class TraceValue < Trace
    # Private API - Methods below here are subject to change, please don't use
    # them directly.

    # @see Trace#match?
    private def match?(hash, key, value, matcher)
      matcher === value
    end
  end
end
