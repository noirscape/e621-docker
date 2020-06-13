class TagNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case Tag.normalize_name(value)
    when /\A_*\z/
      record.errors[attribute] << "'#{value}' cannot be blank"
    when /\*/
      record.errors[attribute] << "'#{value}' cannot contain asterisks ('*')"
    when /,/
      record.errors[attribute] << "'#{value}' cannot contain commas (',')"
    when /#/
      record.errors[attribute] << "'#{value}' cannot contain octothorpes ('#')"
    when /\$/
      record.errors[attribute] << "'#{value}' cannot contain peso signs ('$')"
    when /%/
      record.errors[attribute] << "'#{value}' cannot contain percent signs ('%')"
    when /\\/
      record.errors[attribute] << "'#{value}' cannot contain back slashes ('\\')"
    when /\A~/
      record.errors[attribute] << "'#{value}' cannot begin with a tilde ('~')"
    when /\A-/
      record.errors[attribute] << "'#{value}' cannot begin with a dash ('-')"
    when /\A:/
      record.errors[attribute] << "'#{value}' cannot begin with a colon (':')"
    when /\A_/
      record.errors[attribute] << "'#{value}' cannot begin with an underscore ('_')"
    when /_\z/
      record.errors[attribute] << "'#{value}' cannot end with an underscore ('_')"
    when /[_\-~]{2}/
      record.errors[attribute] << "'#{value}' cannot contain consecutive underscores, hyphens or tildes"
    when /[^[:graph:]]/
      record.errors[attribute] << "'#{value}' cannot contain non-printable characters"
    when /[^[:ascii:]]/
      record.errors[attribute] << "'#{value}' must consist of only ASCII characters"
    when /\A(#{Tag::METATAGS.join("|")}):(.+)\z/i
      record.errors[attribute] << "'#{value}' cannot begin with '#{$1}:'"
    when /\A(#{Tag.categories.regexp}):(.+)\z/i
      record.errors[attribute] << "'#{value}' cannot begin with '#{$1}:'"
    end
  end
end
