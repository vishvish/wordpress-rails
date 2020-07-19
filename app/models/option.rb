# frozen_string_literal: true

# doc comment
class Option < ActiveRecord::Base
  set_table_name 'wp_options'
  set_primary_key 'option_id'

  attr_accessible :option_name, :value

  # needs to be hacked in order to deal with Option requirement in routes.rb for permalinks
  def self.get(option_name)
    option = Option.where(option_name: option_name).first
    if option.nil?
      ' '
    else
      option.value
    end
  rescue ActiveRecord::RecordNotFound
    if option_name == 'permalink_structure'
      NEWS_PERMALINK
    else
      raise StandardError, "Option '#{option_name}' not found.
      Check option name and try again. May not be a valid Wordpress option."
    end
  end

  def self.permalink_route
    option = get('permalink_structure')
    structure = option.tr('%', '').split('/')
    structure.delete_at(0)

    route = ''

    structure.each do |part|
      route << "/:#{part}"
    end

    route
  end

  def value
    option_value
  end
end
