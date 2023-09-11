module Normalizers
  module Combine
    def combine(*fields, type, as:, sep: "")
      _register as

      define_method as do
        _ivar_or_set as do
          combined = @_internal.fetch_values(*fields).compact.join(sep)
          _cast(combined, type)
        end
      end
    end
  end
end