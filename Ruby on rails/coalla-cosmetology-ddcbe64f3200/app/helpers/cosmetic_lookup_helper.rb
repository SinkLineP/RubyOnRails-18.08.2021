module CosmeticLookupHelper

  include LookupHelper

  def file_lookup(code)
    Lookup.find_by(code: code, type_code: 'file')
  end

end