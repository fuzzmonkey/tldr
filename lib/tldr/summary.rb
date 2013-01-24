module Tldr

  class Summary

    def initialize hash
      @h = hash
    end

    def method_missing(method, *opts)
      m = method.to_s
      @h[m] || @h[m.to_s] || super
    end

  end

end