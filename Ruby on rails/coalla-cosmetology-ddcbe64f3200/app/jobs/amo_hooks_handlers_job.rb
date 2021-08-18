AmoHooksHandlersJob = Struct.new(:resource_params, :handler_name, :action_name) do
  def perform
    handler.new(resource_params).send(action_name)
  end

  def handler
    Object.const_get("Amocrm::WebHooks::#{handler_name.capitalize}Handler")
  end

  def failure(job)
    error = StandardError.new("handler: #{handler_name}, actions: #{action_name}. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end

  def max_attempts
    1
  end
end
