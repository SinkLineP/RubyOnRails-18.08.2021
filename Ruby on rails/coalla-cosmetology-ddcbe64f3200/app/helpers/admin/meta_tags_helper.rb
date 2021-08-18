module Admin
  module MetaTagsHelper

    def tag_name(tag)
      t("meta_tag_identifier.#{tag.identifier.gsub('/', '')}")
    end

  end
end