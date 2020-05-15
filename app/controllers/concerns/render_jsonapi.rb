module RenderJsonapi
  extend ActiveSupport::Concern

  included do

    def render_jsonapi(resource, *args)
      options = args.extract_options!
      serializer_options = build_fast_jsonapi_options(options)

      # Paginate
      if resource.is_a?(ActiveRecord::Relation)
        resource = paginate_resource(resource, options[:page])
        serializer_options[:meta].tap do |m|
          m[:current_page] = resource.current_page
          m[:total_pages] = resource.total_pages
        end
      end

      # Serialize
      serializer_key = options[:serializer] || compute_resource_type(resource)
      serializer_class_name = compute_serializer_name(serializer_key)
      serialized_resource = serializer_class_name.new(resource, serializer_options)
      status = options[:status] || :ok

      render json: serialized_resource, status: status
    end

  end

  private

  def paginate_resource(resource, page)
    resource.page(page || 1)
  end

  def compute_serializer_name(serializer_key)
    return serializer_key unless serializer_key.is_a? Symbol

    path = self.class.controller_path.split("/").map { |path| path.capitalize.to_s }
    version = path.take(path.size - 1).join('::')
    serializer_name = serializer_key.to_s.classify + "Serializer"
    ("#{version}::#{serializer_name}").constantize
  end

  def compute_resource_type(resource)
    render_resource_class(resource).base_class.name.to_sym
  end

  def render_resource_class(resource)
    if resource.is_a?(ActiveRecord::Relation)
      # ActiveRecord::Relation has a #klass method to divulge the class of records it contains
      resource_class = resource.klass
    else
      resource_class = resource.class
    end
  end
  
  def build_fast_jsonapi_options(options)
    json_options = {
      params: options[:params] || {},
      meta: options[:meta] || {},
    }
    
    json_options[:include] = includes_array(options[:include]) if options[:include].present?

    json_options
  end

  def includes_array(includes)
    includes.is_a?(Array) ? includes : [includes]
  end
end