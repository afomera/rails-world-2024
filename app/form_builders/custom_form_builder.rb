class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def single_image_uploader(field_name, options = {})
    @template.render "shared/forms/single_image_uploader",
      form: self,
      input_name: "#{object_name}[#{field_name}]",
      field_name: field_name,
      object: self.object,
      object_name: @object_name,
      options: options,
      providers: @object.class.providers_for(field_name)
  end
end
