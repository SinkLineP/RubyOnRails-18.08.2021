module Mindbox
  class Operation
    def initialize(options)
      @options = options
    end

    def to_js
      [operation_type, {
        operation: operation,
        data: data
      }]
    end

    protected

    def operation
      self.class.name.demodulize
    end

    def operation_type
      'async'
    end

    def data; end
  end
end