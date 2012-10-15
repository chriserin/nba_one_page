jQuery ->
  class NbaOnePage.Views.SectionNavigation extends NbaOnePage.Views.ModularView
    el: 'section'
    events:
      'click .up'  : 'navigateUp'
      'click .down': 'navigateDown'

    navigateDown: (event) ->
      $currentTarget = $(event.currentTarget)
      $nextSection = $currentTarget.parents("section").find("+ section")
      if $nextSection.position()
        $("body").animate({scrollTop: "#{($nextSection.position().top)}px"})

    navigateUp: (event) ->
      $currentTarget = $(event.currentTarget)
      $currentSection = $currentTarget.parents("section")
      $nextSection = $currentSection.prev("section")

      if $nextSection and $nextSection.position()
        $("body").animate({scrollTop: "#{($nextSection.position().top)}px"})
