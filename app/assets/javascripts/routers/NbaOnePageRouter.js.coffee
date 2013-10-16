jQuery ->
  class NbaOnePage.Routers.NbaOnePageRouter extends Backbone.Router
    routes:
      ":section_name": "navigateToSection"
      ":section_name/:arg_a": "navigateToSection"
      ":section_name/:arg_a/:arg_b": "navigateToSection"
      ":section_name/:arg_a/:arg_b/:arg_c": "navigateToSection"

    navigateToSection: (section_name, args...) =>
      section = NbaOnePage.ViewState["section_navigation"].navigateTo(section_name)
      if section.updateSection
        section.updateSection(args...)
