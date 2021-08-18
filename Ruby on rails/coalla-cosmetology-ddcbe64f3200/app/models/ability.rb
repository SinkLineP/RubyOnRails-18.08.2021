class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    return unless user

    if controller_namespace == 'Admin' && user.admin?
      can :search, :banks
      can :show, :attendance
      can :manage, InstructorVacation
      can :manage, Classroom
      can :manage, Holiday
      can :manage, ContactsMerge
      can :manage, WorkResult
      can :manage, CampaignIndex
      can :manage, CurriculumBlock
      can :manage, Consultation
      can :manage, UsedTime
      can :manage, Speciality
      can :manage, Advantage
      can :manage, Faq
      can :manage, Campaign
      can :manage, VacancyGroup
      can :manage, Vacancy
      can :manage, Work
      can :manage, PaymentLog
      can :manage, GeneratedDocument
      can :manage, PracticeBasis
      can :manage, Course
      can :manage, Block
      can :manage, Book
      can :manage, Lecture
      can :manage, User
      can :manage, Document
      can :manage, Post
      can :manage, Instructor
      can :manage, StaticPage
      can :manage, Campaign
      can :manage, MagazinePaymentType
      can :manage, Banner
      can :manage, SquareBanner
      can :manage, AmocrmStatus
      can :manage, EducationForm
      can :manage, Faculty
      can :manage, EducationLevel
      can :manage, EducationDocument
      can :manage, Group
      can :load, :post_image
      can :manage, :tutorial
      can :manage, :verification_tutorial
      can :manage, EnPage
      can :manage, Discount
      can :manage, GroupSubscription
      can :manage, Order
      can :manage, Comment
      can :manage, Skill
      can :manage, Recall
      can :manage, Lookup
      can :manage, Partner
      can :manage, HtmlItem
      can :manage, Service
      can :manage, Article
      can :manage, Graduate
      can :manage, HistoryEvent
      can :manage, AboutImage
      can :manage, InstitutionBlock
      can :manage, SiteMetaTags
      can :manage, Promotion
      can :manage, PromoCode
      can :manage, AutomaticDiscount
      can :manage, DocumentSection
      can :manage, UploadedVideo
      can :manage, AmoModule
      can :manage, SurveyResponse
      can :manage, :contingent
    else
      if user.instructor?
        can :manage, AmoModule
        can :read, Student do |student|
          user.students.include?(student)
        end
        can [:show, :update], Result do |result|
          user.students.include?(result.student)
        end
        can :manage, Letter do |letter|
          letter.instructor = user
        end
        can :manage, WorkResult do |work_result|
          user.work_results.where(id: work_result.id).any?
        end
      elsif user.manager?
        can :manage, Classroom
        can :manage, Holiday
        can :manage, InstructorVacation
        can :show, :attendance
        can :manage, ContactsMerge
        can :list, Course
        can :load, :post_image
        can :manage, Partner
        can :manage, Recall
        can :manage, Consultation
        can :manage, UsedTime
        can [:read, :update, :create, :clone, :list, :info], Group
        can :manage, Student
        can :manage, UsedTime
        can :manage, GroupSubscription
        can :manage, Order
        can :manage, GeneratedDocument
        can :manage, PaymentLog
        can :manage, WorkResult
        can :manage, Work
        can [:read, :update, :create], PracticeBasis
        can :manage, Comment
        can :manage, Service
        can :manage, Article
        can :manage, AmoModule
        can :manage, Banner
        can :manage, SquareBanner
        can :manage, Promotion
        can :manage, VacancyGroup
        can :manage, Instructor
      elsif user.student?
        if user.demo?
          can :show, Lecture
          can :pass, Task
        end

        can [:show, :rating], Course do |course|
          [:active, :passed].include?(user.course_status(course))
        end
        can :show, Lecture do |lecture, params|
          course = params[:course]
          user.lecture_status(lecture, course) != :unavailable && user.all_previous_lectures_on_mark_or_passed?(lecture, course)
        end
        can :pass, Task do |task, params|
          course = params[:course]
          user.lecture_task_available?(task, course)
        end
        can :show, Result do |result, params|
          course = params[:course]
          result.student == user && [:active, :passed].include?(user.course_status(course))
        end
        can :show, :progress
        can :index, :vacancies
        can :read, :profile
        can :show, :tutorial unless user.hide_tutorial?
        can :destroy, Notice do |notice|
          user.notices.where(id: notice.id).any?
        end
        can :download, GeneratedDocument
      end
    end

  end
end
