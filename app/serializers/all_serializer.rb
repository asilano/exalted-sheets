class AllSerializer < ActiveModel::Serializer
  def attributes(*args)
    super.merge(object.attributes
                      .symbolize_keys)
         .except(:created_at, :updated_at)
  end
end
