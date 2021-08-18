module ProfileHelper

  def errors_text(f, field)
    content_tag(:div, f.object.errors[field].join(', '), class: 'form_error') if f.object.errors[field]
  end

  def error_data_attributes(f, field)
    {valid: 'false'} if f.object.errors[field].any?
  end

  def avatar_image(user)
    image_tag user.avatar_url(:thumb) || 'avatar.png', alt: user.display_name.html_safe, class: 'avatar-img'
  end

  def avatar_image_url(user, version)
    user.avatar_url(version) || 'avatar.png'
  end

end
