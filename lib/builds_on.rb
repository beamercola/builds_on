module BuildsOn

  def builds_on(name, options={})
    name = name.to_s
    options[:destroy_associations] ||= true
    options[:field_to_be_skipped_if_blank] ||= nil

    define_method "#{name}_attributes=" do |new_attributes|

      # Destroy all previous associations
      #
      eval("self.#{name.pluralize}.each{ |o| o.destroy }") if options[:destroy_associations]
      
      # Clear out any attributes that were left blank
      #
      new_attributes.delete_if{ |e| e[options[:field_to_be_skipped_if_blank]].blank? } unless options[:field_to_be_skipped_if_blank].nil?

      # Build each child
      #
      for data in new_attributes
        eval("self.#{name.pluralize}.build(data)")
      end

    end
  end

end
