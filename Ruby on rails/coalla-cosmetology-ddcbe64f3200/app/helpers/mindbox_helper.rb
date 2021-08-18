module MindboxHelper
  def mindbox(operation, options = {})
    javascript_tag(mindbox_string(operation, options))
  end

  def mindbox_string(operation, options = {})
    json = mindbox_json(operation, options)
    return '' unless json
    "mindboxWrapper.operation(#{json})"
  end

  def mindbox_json(operation, options = {})
    parameters = Mindbox::Operations.operation_parameters(operation, options)
    return unless parameters
    parameters.to_json
  end
end