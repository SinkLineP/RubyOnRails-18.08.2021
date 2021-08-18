module TypographHelper
  def ty(text)
    StandaloneTypograf::Typograf.new(text, mode: :html).prepare.html_safe
  end
end