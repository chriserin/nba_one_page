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
        $("body").animate({scrollTop: "#{($nextSection.position().top) - 35}px"})

    navigateUp: (event) ->
      $currentTarget = $(event.currentTarget)
      $currentSection = $currentTarget.parents("section")
      $nextSection = $currentSection.prev("section")

      if $nextSection and $nextSection.position()
        $("body").animate({scrollTop: "#{($nextSection.position().top) - 35}px"})

    navigateTo: (sectionName) ->
      $section = $("section.#{sectionName}")
      $("body").animate({scrollTop: "#{($section.position().top) - 35}px"})
      @findView(sectionName)

    findView: (sectionName) ->
      for viewName, view of NbaOnePage.ViewState
        if view.el?.classList[0] == sectionName
          return view
