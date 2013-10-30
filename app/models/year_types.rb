module YearTypes
  def make_year_type(year)
    new_type = self.dup
    collection_str =  "#{collection_base_name}.#{year}"
    def new_type.storage_options=(value); @new_storage_options = value; end
    def new_type.storage_options; @new_storage_options; end
    def new_type.year=(value); @year = value; end
    def new_type.year; @year; end
    new_type.storage_options = {collection: collection_str}
    return new_type
  end
end
