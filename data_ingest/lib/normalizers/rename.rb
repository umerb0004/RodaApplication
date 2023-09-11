module Normalizers
  module Rename
    def rename(field, type, as:)
      _register as

      define_method as do
        _ivar_or_set as do
          value = @_internal.fetch(field, nil)
          _cast(value, type)
        end
      end
    end
  end
end