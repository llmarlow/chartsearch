class Chart < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  mount_uploader :picture, PictureUploader
  
   def tag_list
    self.tags.join(", ")
  end

  def tag_list=(tags_string)
    tags_array = tags_string.downcase.split(", ").uniq

    self.tags = tags_array.map do |tag_name|
      Tag.find_or_create_by(name: tag_name)
    end

    self
  end
  
  filterrific(
  available_filters: [
    :with_height_lte,
    :with_price_lte,
    :with_width_lte,
    :with_magazine_only,
    :search_query,
  ]
  )
  scope :with_height_lte, lambda { |height|
    where('charts.height <= ?', height)
  }
  
  scope :with_price_lte, lambda { |price|
    where('charts.price <= ?', price)
  }
  
  scope :with_width_lte, lambda { |width|
    where('charts.width <= ?', width)
  }
  
  scope :with_magazine_only, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    where(is_magazine: true)
  }
  
  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "(LOWER(charts.name) LIKE ?)"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }  
    
end
