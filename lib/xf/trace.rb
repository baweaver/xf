module Xf
  # A more abstract version of a Scope in which the lead key is treated as
  # if it could be anywhere in a hash tree. A Trace will dive until it
  # finds _all_ matching nodes.
  #
  # Note that this can potentially be slow, but is also very difficult to emulate
  # succinctly inline in vanilla Ruby.
  #
  # @author baweaver
  # @since 0.1.0
  #
  class Trace
    # Creates a Scope
    #
    # @param trace_path [Any]
    #   What node to try and locate
    #
    # @return [Xf::Trace]
    def initialize(trace_path)
      @trace_path = trace_path
    end

    # Gets a value from a Hash
    #
    # @param &fn [Proc]
    #   Block to yield the hash, key, and value from any matching element
    #   into. Used to transform returned values upon retrieval
    #
    # @return [Proc[Hash] -> Array]
    #   Array containing matching values, optionally transformed
    def get(&fn)
      Proc.new { |target| get_value(target, &fn) }
    end

    def get_value(hash, &fn)
      retrieved_values = []

      recursing_dive(hash) { |h, k, v|
        retrieved_values.push(block_given? ? fn[h, k, v] : v)
      }

      retrieved_values
    end

    # Sets a value in a Hash
    #
    # @param value = nil [Any]
    #   Value to set at the target
    #
    # @param &fn [Proc]
    #   Block to yield target value to. Returned value will be set as the new
    #   value at the target.
    #
    # @return [Proc[Hash] -> Hash]
    #   New Hash with transformation applied
    def set(value = nil, &fn)
      Proc.new { |hash| set_value(hash, value, &fn) }
    end

    # Mutates a value in a Hash
    #
    # @see #set
    #
    # @note
    #   This method does the same thing as `#set`, except that it mutates the
    #   target value instead of creating a clone first.
    #
    def set!(value = nil, &fn)
      Proc.new { |hash| set_value!(hash, value, &fn) }
    end

    def set_value(hash, value = nil, &fn)
      set_value!(deep_clone(hash), value, &fn)
    end

    def set_value!(hash, value = nil, &fn)
      recursing_dive(hash) { |h, k, v|
        h[k] = block_given? ? yield(v) : value
      }

      hash
    end

    # Private API - Methods below here are subject to change, please don't use
    # them directly.

    # Match is defined as having complete access to a hash, key, and value
    # to make it easier to override for other future fun tasks.
    #
    # In the base case of trace we only _really_ care about the key matching
    # for speed reasons. If you really want power though you could rig this
    # up to work with Qo to query things.
    #
    # @param hash    [Hash] [description]
    # @param key     [Any]  [description]
    # @param value   [Any]  [description]
    # @param matcher [#===] [description]
    #
    # @return [type] [description]
    private def match?(hash, key, value, matcher)
      matcher === key
    end

    private def deep_clone(hash)
      Marshal.load(Marshal.dump(hash))
    end

    private def recursing_dive(target_hash, &fn)
      target_hash.each { |k, v|
        yield(target_hash, k, v) if match?(target_hash, k, v, @trace_path)

        next unless target_hash[k].is_a?(Hash)

        recursing_dive(target_hash[k], &fn)
      }
    end
  end
end
