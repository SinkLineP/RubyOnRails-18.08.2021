# Контроллер раздела "Письма"
# @see app/views/admin/instructors
module Admin
  class LettersController < AdminController
    before_action except: [:index, :new, :create] do
      @letter = current_user.letters.inbound.find(params[:id])
    end

    before_action only: [:new, :create] do
      @students = current_user.students.where('group_subscriptions.end_on >= ?', Date.today).order(:last_name).distinct.map { |g| [g.email, g.id] }
    end

    authorize_resource :letter

    def index
      @letters = current_user.letters.inbound.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def show
      @letter.mark_as_read
    end

    def new
      @letter = Letter.new(student_id: params[:student_id])
    end

    def create
      @letter = current_user.letters.new(params.require(:letter).permit!)
      @letter.assign_attributes(folder: :outbound, sent_at: Time.current)

      if @letter.valid?
        begin
          MailService.new(@letter).send_mail!
        rescue => ex
          CustomExceptionNotifier.notify_exception(ex)
          Rails.logger.error("Failed to send mail. #{ex.message}")
          @sending_error = 'Извините. Произошла ошибка. Пожалуста, повторите попытку.'
          render 'admin/letters/new' and return
        end
        redirect_to admin_letters_path
      else
        render 'admin/letters/new'
      end
    end

    def reply
      reply_letter = @letter
      @letter = Letter.new(subject: "Re: #{reply_letter.subject}",
                           student: reply_letter.student)
    end
  end
end