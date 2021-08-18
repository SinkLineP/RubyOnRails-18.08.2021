var $coursePeriodSelectorSelect = $("#course-period-selector-select");
var $coursePeriodSelectorRange = $("#course-period-selector-range");
var coursePeriodSelectorPeriods = [
  "1 месяц",
  "2 месяца",
  "3 месяца",
  "4 месяца",
  "5 месяцев",
  "6 месяцев",
  "7 месяцев",
  "8 месяцев",
  "9 месяцев",
  "10 месяцев",
  "11 месяцев",
  "12 месяцев"
];
var $courseTypeSelectorList = $("#course-type-selector-list");

function coursePeriodSelectorRange() {
  if (Modernizr.mq(BREAKPOINT_DESKTOP)) {
    if ($coursePeriodSelectorRange.length) {
      $coursePeriodSelectorRange.slider({
        animate: BASE_TRANSITION_DURATION,
        min: 1,
        max: 12,
        step: 1,
        value: $coursePeriodSelectorSelect.val(),
        create: function(event, ui) {
          var $target = $(event.target);
          $target.append(
            '<span class="ui-slider-progress"><span class="ui-slider-percent"></span></span>'
          );

          var value = $target.slider("option", "value") - 1;
          $target
            .find(".ui-slider-handle")
            .text(coursePeriodSelectorPeriods[value]);

          var left = $target.find(".ui-slider-handle").css("left");
          $target.find(".ui-slider-percent").width(left);

          $coursePeriodSelectorSelect.val(value + 1);
          $coursePeriodSelectorSelect.change();
        },
        slide: function(event, ui) {
          var $target = $(event.target);
          var value = ui.value - 1;
          $target
            .find(".ui-slider-handle")
            .text(coursePeriodSelectorPeriods[value]);

          var left = $target.find(".ui-slider-handle").css("left");
          $target.find(".ui-slider-percent").width(left);

          $coursePeriodSelectorSelect.val(value + 1);
          $coursePeriodSelectorSelect.change();
        },
        change: function(event, ui) {
          setTimeout(function() {
            var $target = $(event.target);
            var value = ui.value - 1;
            $target
              .find(".ui-slider-handle")
              .text(coursePeriodSelectorPeriods[value]);

            var left = $target.find(".ui-slider-handle").css("left");
            $target.find(".ui-slider-percent").width(left);

            $coursePeriodSelectorSelect.val(value + 1);
            $coursePeriodSelectorSelect.change();
          }, 300);
        }
      });
    }
  }
}

$("#course-select-toggle").on("click touchend", function() {
  var $this = $(this);

  $this.find(".icon").toggleClass("is-rotated");
  $this.find("> span").toggleText("Скрыть", "Подобрать");

  $("#course-select-content")
    .stop(0)
    .slideToggle(SLIDE_TOGGLE_DURATION);

  setSelect2ContainerProperWidth();

  return false;
});

$("#course-type-selector-list li input").on("change", function() {
  var $this = $(this).parent("li");
  $this.css("pointer-events", "none");

  $this.toggleClass("is-selected");

  setTimeout(function() {
    $this.css("pointer-events", "auto");
  }, 200);
  return false;
});

$(window)
  .load(function() {
    $.each(
      $('#course-type-selector-list li input[name="c[subject][]"]'),
      function() {
        if ($(this).is(":checked")) {
          $(this)
            .parent("li")
            .addClass("is-selected");
        }
      }
    );

    // Course period
    coursePeriodSelectorRange();

    // Course type
  })
  .smartresize(function() {
    coursePeriodSelectorRange();
  });
