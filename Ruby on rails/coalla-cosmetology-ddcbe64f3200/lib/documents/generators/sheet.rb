module Documents
  module Generators
    class Sheet
      include DocBuilder

      def initialize(options = {})
        @options = options
        @work_result = options[:item]
        @work = @work_result.work
        @builder_class = if @work.with_sub_exercises?
                           SheetBuilders::WorkWithSubExercises
                         elsif @work.with_exercises?
                           SheetBuilders::WorkWithoutSubExercises
                         else
                           SheetBuilders::WorkWithSimpleSheet
                         end
      end

      def generate
        build_doc("#{@work.common_form_sheet}_sheet", data)
      end

      def data
        @builder_class.new(@work_result, @options).build_data
      end
    end
  end
end