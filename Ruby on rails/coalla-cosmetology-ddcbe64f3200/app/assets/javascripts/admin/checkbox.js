$(function(){
    $("input:checkbox.js-checkbox-radio").click(function(){
        var $this = $(this);
        var arr = $("input:checkbox.js-checkbox-radio");
        arr.not($this).removeAttr("checked");
        $this.attr("checked", $this.attr("checked"));
        arr.customForm();
    });
});
