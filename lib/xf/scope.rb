module Xf
  # A play on Lenses in Ruby, though not quite as powerful they can be
  # useful for getting and setting deep values on collections.
  #
  # @author baweaver
  # @since 0.0.2
  #
  class Scope
    # Creates a Scope
    # @param paths [Array[Any]] Paths to follow to reach the desired value
    #
    # @return [Xf::Scope]
    def initialize(paths)
      @paths = paths
    end

    # Gets a value from a Hash
    #
    # @return [type] [description]
    def get
      method(:get_value)
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

    # Private API - Methods below here are subject to change, please don't use
    # them directly.

    private def get_value(hash)
      hash.dig(*@paths)
    end

    private def set_value(hash, value = nil, &fn)
      set_value!(deep_clone(hash), value, &fn)
    end

    private def set_value!(hash, value = nil, &fn)
      lead_in    = @paths[0..-2]
      target_key = @paths[-1]

      dive = lead_in.reduce(hash) { |h, s| h[s] }

      new_value = block_given? ?
        yield(dive[target_key]) :
        value

      dive[target_key] = new_value

      hash
    end

    private def deep_clone(hash)
      Marshal.load(Marshal.dump(hash))
    end
  end
end
