module Normalizers
  class Instance
    def self.inherited(subclass)
      subclass.instance_variable_set(:@_fields, [])
      subclass.extend(ClassMethods)
    end

    module ClassMethods
      def params(*fields, type)
        _register *fields

        fields.each do |field|
          define_method field do
            _ivar_or_set(field) do
              value = @_internal.fetch(field, nil)
              _cast(value, type)
            end
          end
        end
      end

      private

      def _register(*fields)
        @_fields.concat fields
      end
    end

    class NoSchema < StandardError; end

    def initialize(data)
      @_internal = data
    end

    def errors
      _validate.errors(full: true).to_h
    rescue NoSchema
      {}
    end

    def errors?
      errors.any?
    end

    def [](field)
      self.send(field)
    end

    def fields
      self.class.instance_variable_get(:@_fields)
    end

    def to_h
      fields.reduce({}) do |memo, field|
        memo[field] = send(field)
        memo
      end
    end

    private

    def _ivar_or_set(field, &block)
      instance_variable_get("@#{field}") || instance_variable_set("@#{field}", yield)
    end

    def _validate
      raise NoSchema, "No schema available for validation" unless self.class.const_defined?(:SCHEMA, false)
      self.class::SCHEMA.(to_h)
    end

    def _cast(obj, type)
      return if obj.nil?
      case type
      when :integer
        obj.to_i
      when :string
        obj.to_s
      when :float
        obj.to_f
      when :date
        Date.iso8601(obj)
      end
    end
  end
end
