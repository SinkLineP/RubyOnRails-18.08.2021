module Share
  extend ActiveSupport::Concern

  included do
    helper_method :share_url, :share_title
  end

  def share_url(params = {})
    json = params.to_json
    encrypted = SymmetricEncryption.encrypt(json)
    root_url(s: encrypted)
  end

  def set_share_meta_tags
    return false if params[:s].blank?
    decrypted = SymmetricEncryption.decrypt(params[:s])
    share_params = ActiveSupport::JSON.decode(decrypted).with_indifferent_access
    title = share_title(share_params)
    set_meta_tags title: title, og: {
                                  title: title,
                                  url: root_url(s: params[:s]),
                                  image: root_url + 'assets/share.jpg'
                              }
    true
  rescue => ex
    Rails.logger.error("Couldn't parse share params. #{ex.message}")
    false
  end

  def share_title(share_params)
    method_name = "#{share_params[:type].to_s}_title"
    send(method_name, share_params)
  end

  #titles

  def course_title(share_params)
    user = User.find(share_params[:user])
    course = Course.find(share_params[:course])
    "#{user.display_name} учится на курсе #{course.name} в Доме Русской Косметики"
  end

  def block_title(share_params)
    user = User.find(share_params[:user])
    block = Block.find(share_params[:block])
    course = Course.find(share_params[:course])
    "#{user.display_name} изучает #{block.name} в курсе #{course.try(:name)}"
  end

  def lecture_title(share_params)
    user = User.find(share_params[:user])
    lecture = Lecture.find(share_params[:lecture])
    course = Course.find(share_params[:course])
    "#{user.display_name} изучает #{lecture.description} в курсе #{course.try(:name)}"
  end

  def task_title(share_params)
    user = User.find(share_params[:user])
    task = Task.find(share_params[:task])
    course = Course.find(share_params[:course])
    "Поздравляем #{user.display_name} с успешной сдачей теста по курсу #{course.name}"
  end

  def progress_title(share_params)
    user = User.find(share_params[:user])
    "#{user.display_name} учится в Доме Русской Косметики"
  end
end