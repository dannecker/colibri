root = exports ? this

root.taxon_tree_menu = (obj, context) ->

  base_url = Colibri.url(Colibri.routes.taxonomy_taxons_path)
  admin_base_url = Colibri.url(Colibri.routes.admin_taxonomy_taxons_path)
  edit_url = admin_base_url.clone()
  edit_url.setPath(edit_url.path() + '/' + obj.attr("id") + "/edit");

  create:
    label: "<i class='icon-plus'></i> " + Colibri.translations.add,
    action: (obj) -> context.create(obj)
  rename:
    label: "<i class='icon-pencil'></i> " + Colibri.translations.rename,
    action: (obj) -> context.rename(obj)
  remove:
    label: "<i class='icon-trash'></i> " + Colibri.translations.remove,
    action: (obj) -> context.remove(obj)
  edit:
    separator_before: true,
    label: "<i class='icon-edit'></i> " + Colibri.translations.edit,
    action: (obj) -> window.location = edit_url.toString()
