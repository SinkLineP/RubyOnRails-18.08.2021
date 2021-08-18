module CommonHelpers
  def test_model_name
    described_class.to_s.underscore.to_sym
  end
end