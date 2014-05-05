//= require handlebars
Handlebars.registerHelper("t", function(key) {
  if (Colibri.translations[key]) {
    return Colibri.translations[key]
  } else {
    console.error("No translation found for " + key + ". Does it exist within colibri/admin/shared/_translations.html.erb?")
  }
});

