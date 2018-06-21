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
    def get(&fn)
      Proc.new { |hash| get_value(hash, &fn) }
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

    # Direct value getter, though it may be wiser to use Hash#dig here
    # instead if you're concerned about speed.
    #
    # @param hash [Hash] Hash to get value from
    #
    # @return [Any]
    def get_value(hash, &fn)
      value = hash.dig(*@paths)

      block_given? ? fn[value] : value
    end

    # Sets a value at the bottom of a path without mutating the original.
    #
    # @param hash [Hash]
    #   Hash to set value on
    #
    # @param value = nil [Any]
    #   Value to set
    #
    # @param &fn [Proc]
    #   If present, current value is yielded to it and the return
    #   value is the new set value
    #
    # @return [Hash]
    #   Clone of the original with the value set
    def set_value(hash, value = nil, &fn)
      set_value!(deep_clone(hash), value, &fn)
    end

    # Mutating form of `#set_value`
    #
    # @see set_value
    def set_value!(hash, value = nil, &fn)
      lead_in    = @paths[0..-2]
      target_key = @paths[-1]

      new_hash = hash
      lead_in.each { |s| new_hash = new_hash[s] }

      new_value = block_given? ?
        yield(new_hash[target_key]) :
        value

      new_hash[target_key] = new_value

      hash
    end

    # Private API - Methods below here are subject to change, please don't use
    # them directly.

    private def deep_clone(hash)
      Marshal.load(Marshal.dump(hash))
    end
  end
end
