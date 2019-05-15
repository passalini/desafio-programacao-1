module MiniTestWithBullet
  def setup
    Bullet.start_request
    super if defined?(super)
  end

  def teardown
    super if defined?(super)

    if Bullet.warnings.present?
      warnings = Bullet.warnings.map{ |_k, warning| warning }.flatten.map{|warn| warn.body_with_caller}.join("\n-----\n\n")

      flunk(warnings)
    end

    Bullet.end_request
  end
end

class ActiveSupport::TestCase
  include MiniTestWithBullet
end
