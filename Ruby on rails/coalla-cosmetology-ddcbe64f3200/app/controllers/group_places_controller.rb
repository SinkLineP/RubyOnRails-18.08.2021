class GroupPlacesController < ApplicationController
  layout false
  GROUPS = [['Косметология', %w[EST THE PREST KC KV SK K-dist PREST-2021 THE-2021 EST-2021 KVIP-2021 KBAZ-2021 KOPT-2021]],
            ['Группы предпенсионеров', %w[K-WSR PU-WSR UT-WSR UL-WSR-BM UL-WSR-Med ML-WSR AK-WSR WSR-EXPRESS-UL-144 WSR-EXPRESS-UT-144 WSR-EXPRESS-PU-144]],
            ['Массаж', %w[SPA-M MM SPORT-M]],
            ['Парикмахеры', %w[P PU PS BR]]].freeze
  ALL_GROUPS = GROUPS.flat_map{ |gr| gr[1] }.freeze

  def index
    @groups = GROUPS.map do |group|
      scope = GroupPlace.statistics
      scope = scope.with_courses(group[1]) if group[1].present?
      [ scope.group_by { |gr| gr.min_begin_practice_date.beginning_of_month } ] + group
    end
    ['Все группы', ALL_GROUPS]
    scope = AnotherGroupPlace.statistics.with_courses(ALL_GROUPS)
    @groups = @groups + [[ scope.group_by { |gr| gr.min_begin_practice_date.beginning_of_month } ] + ['Все группы', ALL_GROUPS]]
  end
end
