Colibri::Sample.load_sample("option_types")

size = Colibri::OptionType.find_by_presentation!("Size")
color = Colibri::OptionType.find_by_presentation!("Color")

Colibri::OptionValue.create!([
  {
    :name => "Small",
    :presentation => "S",
    :position => 1,
    :option_type => size
  },
  {
    :name => "Medium",
    :presentation => "M",
    :position => 2,
    :option_type => size
  },
  {
    :name => "Large",
    :presentation => "L",
    :position => 3,
    :option_type => size
  },
  {
    :name => "Extra Large",
    :presentation => "XL",
    :position => 4,
    :option_type => size
  },
  {
    :name => "Red",
    :presentation => "Red",
    :position => 1,
    :option_type => color,
  },
  {
    :name => "Green",
    :presentation => "Green",
    :position => 2,
    :option_type => color,
  },
  {
    :name => "Blue",
    :presentation => "Blue",
    :position => 3,
    :option_type => color
  }
])
