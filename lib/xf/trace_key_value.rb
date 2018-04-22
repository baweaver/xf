module Xf
  # Traces based on a key and a value matching. Only overrides the `match?`
  # method to redefine a matched node.
  #
  # @author baweaver
  # @since 0.1.0
  #
  class TraceKeyValue < Trace
    def initialize(trace_key, trace_value)
      @trace_key   = trace_key
      @trace_value = trace_value
    end

    # Private API - Methods below here are subject to change, please don't use
    # them directly.

    # @see Trace#match?
    private def match?(hash, key, value, matcher)
      @trace_key === key && @trace_value === value
    end
  end
end
