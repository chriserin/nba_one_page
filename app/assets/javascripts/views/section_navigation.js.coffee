jQuery ->
  class NbaOnePage.Views.SectionNavigation extends NbaOnePage.Views.ModularView
    el: 'section'

    navigateTo: (sectionName) ->
      $section = $("section.#{sectionName}")
      $("body").animate({scrollTop: "#{($section.position().top) - 35}px"})
      @findView(sectionName)

    findView: (sectionName) ->
      for viewName, view of NbaOnePage.ViewState
        if view.el?.classList[0] == sectionName
          return view
