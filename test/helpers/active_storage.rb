module Helpers
  module ActiveStorage
    def assert_have_one_attached(klass, attachment_name)
      object = klass.new
      assert_respond_to(object, attachment_name)
      assert_equal(::ActiveStorage::Attached::One, object.file.class)
    end
  end
end

class ActiveSupport::TestCase
  include Helpers::ActiveStorage

  def remove_uploaded_files
    path = "#{Rails.root}/tmp/storage/**/*"
    files = Dir[path].reject { |a| a.include?('/8A') }
    FileUtils.rm_rf(files)
  end

  def after_teardown
    super
    remove_uploaded_files
  end
end
