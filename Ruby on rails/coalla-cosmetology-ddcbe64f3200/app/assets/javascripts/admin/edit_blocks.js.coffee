#= require_self
#= require_tree ./blocks
#= require_tree ./blocks/models
#= require_tree ./blocks/views
window.B ||= {}

$ ->
  new B.BlockForm()