class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def self.strong_parameted attrs = nil
    model = self.name.to_s[0..-11].split('::').last.singularize
    model_sym = model.underscore.to_sym
    if attrs
      attrs.map! {|elem| (elem == :all ? (model.constantize.column_names - ['id', 'updated_at', 'created_at']).map!(&:to_sym) : elem) }
    else
      attrs = (model.constantize.column_names - ['id', 'updated_at', 'created_at']).map!(&:to_sym)
    end

    define_method :resource_params do
      return [] if request.get?
      [params.require(model_sym).permit(attrs)]
    end
  end

end
